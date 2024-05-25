module CsvImporter
  require 'csv'
  require 'thread'

  def import_movies_csv(csv_file)
    failed_transactions = []
    batch_size = 1000
    batch = []
    threads = []
    mutex = Mutex.new

    CSV.open(csv_file.path, headers: true).each do |row|
      batch << row
      if batch.size >= batch_size
        threads << Thread.new(batch, failed_transactions, mutex) do |batch, failed_transactions, mutex|
          process_movie_batch(batch, failed_transactions, mutex)
        end
        batch = []
      end
    end

    if batch.any?
      threads << Thread.new(batch, failed_transactions, mutex) do |batch, failed_transactions, mutex|
        process_movie_batch(batch, failed_transactions, mutex)
      end
    end

    threads.each(&:join)

    if failed_transactions.any?
      puts "Failed to import the following movies: #{failed_transactions.join(', ')}"
      return failed_transactions
    end

    puts "All movies imported successfully."
    return []
  end

  def process_movie_batch(batch, failed_transactions, mutex)
    movie_inserts = []
    actor_updates = {}
    batch.each do |row|
      movie = Movie.find_by(title: row['Movie'])
      if movie
        new_actor = row['Actor'].strip
        actor_updates[movie.id] ||= []
        actor_updates[movie.id] << new_actor unless movie.actors.include?(new_actor)
      else
        movie_inserts << {
          title: row['Movie'],
          description: row['Description'],
          director: row['Director'],
          actors: [row['Actor'].strip],
          year: row['Year'],
          filming_location: row['Filming location'],
          country: row['Country'],
          created_at: Time.now,
          updated_at: Time.now
        }
      end
    end

    ActiveRecord::Base.transaction do
      Movie.insert_all(movie_inserts) if movie_inserts.any?
      actor_updates.each do |movie_id, actors|
        movie = Movie.find(movie_id)
        movie.actors += actors
        movie.actors.uniq!
        movie.save!
      end
    end
  rescue => e
    batch.each do |row|
      mutex.synchronize { failed_transactions << row['Movie'] }
    end
  end

  def import_reviews_csv(csv_file)
    failed_transactions = []
    batch_size = 1000
    batch = []
    threads = []
    mutex = Mutex.new

    movie_titles = Movie.pluck(:title, :id).to_h

    CSV.open(csv_file.path, headers: true).each do |row|
      batch << row
      if batch.size >= batch_size
        threads << Thread.new(batch, failed_transactions, mutex, movie_titles) do |batch, failed_transactions, mutex, movie_titles|
          process_review_batch(batch, failed_transactions, mutex, movie_titles)
        end
        batch = []
      end
    end

    if batch.any?
      threads << Thread.new(batch, failed_transactions, mutex, movie_titles) do |batch, failed_transactions, mutex, movie_titles|
        process_review_batch(batch, failed_transactions, mutex, movie_titles)
      end
    end

    threads.each(&:join)

    if failed_transactions.any?
      puts "Failed to import the following reviews: #{failed_transactions.join(', ')}"
      return failed_transactions
    end

    puts "All reviews imported successfully."
    return []
  end

  def process_review_batch(batch, failed_transactions, mutex, movie_titles)
    review_inserts = []
    batch.each do |row|
      movie_id = movie_titles[row['movie_title']]
      if movie_id
        review_inserts << {
          movie_id: movie_id,
          reviewer: row['reviewer'],
          stars: row['stars'],
          review: row['review'],
          created_at: Time.now,
          updated_at: Time.now
        }
      else
        mutex.synchronize { failed_transactions << row['review_id'] }
      end
    end

    ActiveRecord::Base.transaction do
      Review.insert_all(review_inserts) if review_inserts.any?
    end
  rescue => e
    batch.each do |row|
      mutex.synchronize { failed_transactions << row['review_id'] }
    end
  end
end
