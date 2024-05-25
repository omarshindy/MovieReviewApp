class CsvImportsController < ApplicationController
  include CsvImporter

  def new
  end

  def import_movies
    csv_file = params[:csv_file]

    if csv_file
      if valid_movies_csv_structure?(csv_file)
        start_time = Time.now
        import_movies_csv(csv_file)
        end_time = Time.now
        duration = end_time - start_time
        redirect_to import_csv_path, notice: "Movies CSV file imported successfully in #{duration.round(2)} seconds."
      else
        redirect_to import_csv_path, alert: 'Invalid CSV structure for movies.'
      end
    else
      redirect_to import_csv_path, alert: 'Please upload a CSV file.'
    end
  end

  def import_reviews
    csv_file = params[:csv_file]

    if csv_file
      if valid_reviews_csv_structure?(csv_file)
        start_time = Time.now
        import_reviews_csv(csv_file)
        end_time = Time.now
        duration = end_time - start_time
        redirect_to movies_path, notice: "Reviews CSV file imported successfully in #{duration.round(2)} seconds."
      else
        redirect_to import_csv_path, alert: 'Invalid CSV structure for reviews.'
      end
    else
      redirect_to import_csv_path, alert: 'Please upload a CSV file.'
    end
  end

  def valid_movies_csv_structure?(csv_file)
    expected_headers = ["Movie", "Description", "Director", "Actor", "Year", "Filming location", "Country"]
    csv = CSV.read(csv_file.path, headers: true)
    (expected_headers - csv.headers).empty?
  end

  def valid_reviews_csv_structure?(csv_file)
    expected_headers = ["movie_title", "reviewer", "stars", "review"]
    csv = CSV.read(csv_file.path, headers: true)
    (expected_headers - csv.headers).empty?
  end
end
