class ApplicationController < ActionController::Base
  # セッションを有効にする
  protect_from_forgery with: :exception
end
