# app/models/movie.rb
class Movie < ApplicationRecord
    has_many :reviews, dependent: :destroy
  
    validates :title, presence: true, uniqueness: true
    validates :year, presence: true
    validates :actors, presence: true
  end
  