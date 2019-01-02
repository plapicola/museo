require_relative 'test_helper'

class CuratorTest < Minitest::Test

  def setup
    @curator = Curator.new

    @photo_1 = {
                id: "1",
                name: "Rue Mouffetard, Paris (Boy with Bottles)",
                artist_id: "1",
                year: "1954"
                }
    @photo_2 = {
                id: "2",
                name: "Moonrise, Hernandez",
                artist_id: "2",
                year: "1941"
                }
    @photo_3 = {
                id: "3",
                name: "Identical Twins, Roselle, New Jersey",
                artist_id: "3",
                year: "1967"
                }
    @photo_4 = {
                id: "4",
                name: "Child with Toy Hand Grenade in Central Park",
                artist_id: "3",
                year: "1962"
              }

    @artist_1 = {
                  id: "1",
                  name: "Henri Cartier-Bresson",
                  born: "1908",
                  died: "2004",
                  country: "France"
                }

    @artist_2 = {
                  id: "2",
                  name: "Ansel Adams",
                  born: "1902",
                  died: "1984",
                  country: "United States"
                }

    @artist_3 = {
                  id: "3",
                  name: "Diane Arbus",
                  born: "1923",
                  died: "1971",
                  country: "United States"
                }
  end

  def test_it_exists
    assert_instance_of Curator, @curator
  end

  def test_it_has_no_artists_by_default
    assert_equal [], @curator.artists
  end

  def test_it_has_no_pictures_by_default
    assert_equal [], @curator.photographs
  end

  def test_it_can_add_photographs
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    @curator.photographs.each do |photo|
      assert_instance_of Photograph, photo
    end
    assert_equal 2, @curator.photographs.count
  end

  def test_it_can_add_artists
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    @curator.artists.each do |artist|
      assert_instance_of Artist, artist
    end
    assert_equal 2, @curator.artists.count
  end

  def test_it_can_find_artists_by_id
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)

    assert_equal @artist_1[:name], @curator.find_artist_by_id("1").name
    assert_nil @curator.find_artist_by_id("3")
  end

  def test_it_can_find_photos_by_id
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)

    assert_equal @photo_2[:name], @curator.find_photograph_by_id("2").name
    assert_nil @curator.find_photograph_by_id("5")
  end

  def test_it_can_find_all_photos_by_artist
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_3)

    diane_arbus = @curator.find_artist_by_id("3")

    assert_equal 2, @curator.find_photographs_by_artist(diane_arbus).length
    assert_instance_of Photograph, @curator.find_photographs_by_artist(diane_arbus).first
  end

  def test_it_can_find_artists_with_multiple_photographs
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)
    diane_arbus = @curator.find_artist_by_id("3")

    assert_equal [diane_arbus], @curator.artists_with_multiple_photographs
  end

  def test_it_can_find_photographs_taken_by_artist_from_region
    @curator.add_photograph(@photo_1)
    @curator.add_photograph(@photo_2)
    @curator.add_photograph(@photo_3)
    @curator.add_photograph(@photo_4)
    @curator.add_artist(@artist_1)
    @curator.add_artist(@artist_2)
    @curator.add_artist(@artist_3)

    assert_equal 3, @curator.photographs_taken_by_artist_from("United States").length
    assert_equal [], @curator.photographs_taken_by_artist_from("Argentina")
  end

  def test_it_can_load_photographs_from_file
    @curator.load_photographs('./data/photographs.csv')

    assert_equal @photo_1[:name], @curator.find_photograph_by_id("1").name
  end

  def test_it_can_load_artists_from_file
    @curator.load_artists('./data/artists.csv')

    assert_equal @artist_1[:name], @curator.find_artist_by_id("1").name
  end

  def test_it_can_find_all_photographs_taken_in_range
    @curator.load_photographs('./data/photographs.csv')

    assert_equal @photo_1[:name], @curator.find_photographs_taken_between(1950..1965).first.name
    assert_equal @photo_4[:name], @curator.find_photographs_taken_between(1950..1965).last.name
  end

  def test_it_can_return_a_hash_of_photos_taken_by_artist_age
    @curator.load_photographs('./data/photographs.csv')
    @curator.load_artists('./data/artists.csv')

    diane_arbus = @curator.find_artist_by_id("3")

    expected = {44=>"Identical Twins, Roselle, New Jersey",
                39=>"Child with Toy Hand Grenade in Central Park"}

    assert_equal expected, @curator.artists_photographs_by_age(diane_arbus)
  end
end
