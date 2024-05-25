namespace :import do
    desc "Import movies and reviews from CSV files"
    task movies: :environment do
      require 'csv'
      include CsvImporter
  
      movies_file = Rails.root.join('data/movies.csv')
      reviews_file = Rails.root.join('data/reviews.csv')
  
      start_time = Time.now
  
      if valid_movies_csv_structure?(movies_file)
        import_movies_csv(File.open(movies_file))
        puts "Movies CSV file imported successfully."
      else
        puts "Invalid CSV structure for movies."
      end
  
      if valid_reviews_csv_structure?(reviews_file)
        import_reviews_csv(File.open(reviews_file))
        puts "Reviews CSV file imported successfully."
      else
        puts "Invalid CSV structure for reviews."
      end
  
      end_time = Time.now
      duration = end_time - start_time
      puts "Total import time: #{duration.round(2)} seconds."
    end
  end
  