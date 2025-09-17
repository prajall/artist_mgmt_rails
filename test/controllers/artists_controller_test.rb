require "test_helper"

class ArtistsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @artist = artists(:one)
  end

  test "should get index" do
    get artists_url, as: :json
    assert_response :success
  end

  test "should create artist" do
    assert_difference("Artist.count") do
      post artists_url, params: { artist: { artist_name: @artist.artist_name, first_release_year: @artist.first_release_year, no_of_albums_released: @artist.no_of_albums_released } }, as: :json
    end

    assert_response :created
  end

  test "should show artist" do
    get artist_url(@artist), as: :json
    assert_response :success
  end

  test "should update artist" do
    patch artist_url(@artist), params: { artist: { artist_name: @artist.artist_name, first_release_year: @artist.first_release_year, no_of_albums_released: @artist.no_of_albums_released } }, as: :json
    assert_response :success
  end

  test "should destroy artist" do
    assert_difference("Artist.count", -1) do
      delete artist_url(@artist), as: :json
    end

    assert_response :no_content
  end
end
