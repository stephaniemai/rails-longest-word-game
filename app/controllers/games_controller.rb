require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ("A".."Z").to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    # raise
    # render plain: "The word '#{@word}' is an English word: #{dictionary?(@word)}."
    # render plain: "#{@word} in grid: '#{grid?(@word, @letters)}'."
    @score =
      if dictionary?(@word) && grid?(@word, @letters)
        "Congratulations! #{@word.upcase} is a valid English word!"
      elsif !grid?(@word, @letters)
        "Sorry but #{@word.upcase} can't be built out of #{@letters}"
      else
        "Sorry but #{@word.upcase} does not seem to be an English word..."
      end
  end

  def dictionary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{word}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    word['found']
  end

  def grid?(word, grid)
    word = word.upcase
    grid = grid.chars
    word.chars.all? { |letter| word.count(letter) <= grid.count(letter) }
  end

  private

  # Finds the User with the ID stored in the session with the key
  # :current_user_id This is a common way to handle user login in
  # a Rails application; logging in sets the session value and
  # logging out removes it.
  def current_user
    @current_user ||= session[:current_user_id] &&
                      User.find_by(id: session[:current_user_id])
  end
end
