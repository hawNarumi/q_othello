require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  test "should get root and redirect to game" do
    get root_url
    assert_redirected_to game_url
  end

  test "should start new game" do
    get new_game_url
    assert_redirected_to game_url
    assert session[:game].present?
  end

  test "should show game" do
    get new_game_url
    get game_url
    assert_response :success
  end

  test "should redirect to new game when session is missing" do
    get game_url
    assert_redirected_to new_game_url
  end

  test "should make a valid move" do
    get new_game_url
    post move_url, params: { row: 2, col: 3 }

    assert_redirected_to game_url
    assert flash[:success].present?
  end

  test "should reject an invalid move" do
    get new_game_url
    post move_url, params: { row: 0, col: 0 }

    assert_redirected_to game_url
    assert flash[:error].present?
  end

  test "should reset game" do
    get new_game_url
    post move_url, params: { row: 2, col: 3 }
    post reset_url

    assert_redirected_to game_url
    game = OthelloBoard.from_hash(session[:game])
    assert_equal 2, game.black_count
    assert_equal 2, game.white_count
    assert_equal OthelloBoard::BLACK, game.current_player
  end
end
