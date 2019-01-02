require_relative 'artist'
require_relative 'photograph'
require 'csv'

class Curator

  attr_reader :artists,
              :photographs

  def initialize
    @photographs = []
    @artists = []
  end

  def load_artists(location)
    file = File.new(location)
    csv = CSV.new(file, headers: true,
                        header_converters: :symbol)
    csv.read.each do |row|
      add_artist(row)
    end
  end

  def load_photographs(location)
    file = File.new(location)
    csv = CSV.new(file, headers: true,
                        header_converters: :symbol,
                        col_sep: ",,")
    csv.read.each do |row|
      add_photograph(row)
    end
  end

  def add_artist(info)
    artist = Artist.new(info)
    @artists << artist
  end

  def add_photograph(info)
    photograph = Photograph.new(info)
    @photographs << photograph
  end

  def find_artist_by_id(id)
    @artists.find do |artist|
      artist.id == id
    end
  end

  def find_photograph_by_id(id)
    @photographs.find do |photo|
      photo.id == id
    end
  end

  def find_photographs_by_artist(artist)
    @photographs.find_all do |photo|
      photo.artist_id == artist.id
    end
  end

  def artists_with_multiple_photographs
    @artists.find_all do |artist|
      find_photographs_by_artist(artist).length > 1
    end
  end

  def photographs_taken_by_artist_from(country)
    found_photos = []
    @artists.each do |artist|
      if artist.country == country
        found_photos << find_photographs_by_artist(artist)
      end
    end
    found_photos.flatten
  end

  def find_photographs_taken_between(range)
    @photographs.find_all do |photo|
      range.include?(photo.year.to_i)
    end
  end

  def artists_photographs_by_age(artist)
    grouped_photos = {}
    find_photographs_by_artist(artist).each do |photo|
      grouped_photos[photo.year.to_i - artist.born.to_i] = photo.name
    end
    grouped_photos
  end
end
