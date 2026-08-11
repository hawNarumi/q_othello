require "test_helper"

class OthelloBoardTest < ActiveSupport::TestCase
  let(:game) { OthelloBoard.new }

  test "initial board has correct setup" do
    assert_equal 8, OthelloBoard::BOARD_SIZE
    assert_equal OthelloBoard::BLACK, game.current_player
    assert_equal 2, game.black_count
    assert_equal 2, game.white_count
    assert_not game.game_over
    assert_nil game.winner

    assert_equal OthelloBoard::WHITE, game.board[3][3]
    assert_equal OthelloBoard::BLACK, game.board[3][4]
    assert_equal OthelloBoard::BLACK, game.board[4][3]
    assert_equal OthelloBoard::WHITE, game.board[4][4]
  end

  test "valid moves exist at start" do
    valid_moves = game.get_valid_moves

    assert_includes valid_moves, [ 2, 3 ]
    assert_includes valid_moves, [ 3, 2 ]
    assert_includes valid_moves, [ 4, 5 ]
    assert_includes valid_moves, [ 5, 4 ]
  end

  test "make_move flips pieces and switches player" do
    assert game.make_move(2, 3)
    assert_equal OthelloBoard::BLACK, game.board[3][3]
    assert_equal OthelloBoard::WHITE, game.current_player
    assert_equal 4, game.black_count
    assert_equal 1, game.white_count
  end

  test "invalid move returns false" do
    assert_not game.make_move(0, 0)
    assert_equal OthelloBoard::BLACK, game.current_player
    assert_equal 2, game.black_count
    assert_equal 2, game.white_count
  end

  test "to_hash and from_hash preserve state" do
    game.make_move(2, 3)

    hash = game.to_hash
    restored = OthelloBoard.from_hash(hash)

    assert_equal game.board, restored.board
    assert_equal game.current_player, restored.current_player
    assert_equal game.game_over, restored.game_over
    assert_nil restored.winner
    assert_equal game.black_count, restored.black_count
    assert_equal game.white_count, restored.white_count
  end

  test "current_player_name returns correct name" do
    assert_equal "黒", game.current_player_name

    game.current_player = OthelloBoard::WHITE
    assert_equal "白", game.current_player_name
  end

  test "winner_name returns correct name" do
    game.winner = OthelloBoard::BLACK
    assert_equal "黒", game.winner_name

    game.winner = OthelloBoard::WHITE
    assert_equal "白", game.winner_name

    game.winner = nil
    assert_equal "引き分け", game.winner_name
  end

  test "game ends when neither player can move" do
    # Fill the board to force end of game
    (0...OthelloBoard::BOARD_SIZE).each do |row|
      (0...OthelloBoard::BOARD_SIZE).each do |col|
        game.board[row][col] = OthelloBoard::BLACK
      end
    end
    game.board[0][0] = OthelloBoard::EMPTY
    game.board[0][1] = OthelloBoard::WHITE
    game.current_player = OthelloBoard::BLACK

    assert game.make_move(0, 0)
    assert game.game_over
    assert_equal OthelloBoard::BLACK, game.winner
  end
end
