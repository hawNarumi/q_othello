class OthelloBoard
  BOARD_SIZE = 8
  EMPTY = 0
  BLACK = 1
  WHITE = 2
  
  attr_accessor :board, :current_player, :game_over, :winner, :black_count, :white_count
  
  def initialize
    @board = Array.new(BOARD_SIZE) { Array.new(BOARD_SIZE, EMPTY) }
    @current_player = BLACK
    @game_over = false
    @winner = nil
    @black_count = 2
    @white_count = 2
    
    # 初期配置
    @board[3][3] = WHITE
    @board[3][4] = BLACK
    @board[4][3] = BLACK
    @board[4][4] = WHITE
  end
  
  def self.from_hash(data)
    game = new
    game.board = data['board']
    game.current_player = data['current_player']
    game.game_over = data['game_over']
    game.winner = data['winner']
    game.black_count = data['black_count']
    game.white_count = data['white_count']
    game
  end
  
  def to_hash
    {
      'board' => @board,
      'current_player' => @current_player,
      'game_over' => @game_over,
      'winner' => @winner,
      'black_count' => @black_count,
      'white_count' => @white_count
    }
  end
  
  def make_move(row, col)
    return false unless valid_move?(row, col)
    
    @board[row][col] = @current_player
    flip_pieces(row, col)
    update_counts
    
    @current_player = (@current_player == BLACK) ? WHITE : BLACK
    
    # 次のプレイヤーが打てる手があるかチェック
    unless has_valid_moves?(@current_player)
      # 相手プレイヤーに戻す
      @current_player = (@current_player == BLACK) ? WHITE : BLACK
      
      # 両方のプレイヤーが打てない場合、ゲーム終了
      unless has_valid_moves?(@current_player)
        end_game
      end
    end
    
    true
  end
  
  def valid_move?(row, col)
    return false if row < 0 || row >= BOARD_SIZE || col < 0 || col >= BOARD_SIZE
    return false if @board[row][col] != EMPTY
    return false if @game_over
    
    directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    
    directions.any? do |dr, dc|
      can_flip_in_direction?(row, col, dr, dc)
    end
  end
  
  def get_valid_moves
    moves = []
    (0...BOARD_SIZE).each do |row|
      (0...BOARD_SIZE).each do |col|
        moves << [row, col] if valid_move?(row, col)
      end
    end
    moves
  end
  
  def current_player_name
    @current_player == BLACK ? '黒' : '白'
  end
  
  def winner_name
    case @winner
    when BLACK then '黒'
    when WHITE then '白'
    else '引き分け'
    end
  end
  
  private
  
  def can_flip_in_direction?(row, col, dr, dc)
    r, c = row + dr, col + dc
    opponent = (@current_player == BLACK) ? WHITE : BLACK
    found_opponent = false
    
    while r >= 0 && r < BOARD_SIZE && c >= 0 && c < BOARD_SIZE
      if @board[r][c] == EMPTY
        return false
      elsif @board[r][c] == opponent
        found_opponent = true
      elsif @board[r][c] == @current_player
        return found_opponent
      end
      
      r += dr
      c += dc
    end
    
    false
  end
  
  def flip_pieces(row, col)
    directions = [[-1, -1], [-1, 0], [-1, 1], [0, -1], [0, 1], [1, -1], [1, 0], [1, 1]]
    
    directions.each do |dr, dc|
      if can_flip_in_direction?(row, col, dr, dc)
        flip_in_direction(row, col, dr, dc)
      end
    end
  end
  
  def flip_in_direction(row, col, dr, dc)
    r, c = row + dr, col + dc
    opponent = (@current_player == BLACK) ? WHITE : BLACK
    
    while r >= 0 && r < BOARD_SIZE && c >= 0 && c < BOARD_SIZE && @board[r][c] == opponent
      @board[r][c] = @current_player
      r += dr
      c += dc
    end
  end
  
  def has_valid_moves?(player)
    original_player = @current_player
    @current_player = player
    
    has_moves = (0...BOARD_SIZE).any? do |row|
      (0...BOARD_SIZE).any? do |col|
        valid_move?(row, col)
      end
    end
    
    @current_player = original_player
    has_moves
  end
  
  def update_counts
    @black_count = 0
    @white_count = 0
    
    @board.each do |row|
      row.each do |cell|
        @black_count += 1 if cell == BLACK
        @white_count += 1 if cell == WHITE
      end
    end
  end
  
  def end_game
    @game_over = true
    
    if @black_count > @white_count
      @winner = BLACK
    elsif @white_count > @black_count
      @winner = WHITE
    else
      @winner = nil # 引き分け
    end
  end
end
