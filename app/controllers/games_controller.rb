class GamesController < ApplicationController
  before_action :load_game, except: [:new]
  
  def new
    session[:game] = OthelloBoard.new.to_hash
    redirect_to game_path
  end
  
  def show
    @valid_moves = @game.get_valid_moves
  end
  
  def move
    row = params[:row].to_i
    col = params[:col].to_i
    
    if @game.make_move(row, col)
      session[:game] = @game.to_hash
      flash[:success] = "#{@game.current_player == OthelloBoard::BLACK ? '白' : '黒'}が石を置きました"
    else
      flash[:error] = "そこには置けません"
    end
    
    redirect_to game_path
  end
  
  def reset
    session[:game] = OthelloBoard.new.to_hash
    redirect_to game_path
  end
  
  private
  
  def load_game
    if session[:game]
      @game = OthelloBoard.from_hash(session[:game])
    else
      redirect_to new_game_path
    end
  end
end
