require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @letters = []
    10.times { @letters << ("A".."Z").to_a.sample }
  end

  def score
    @word = params[:word]
    render plain: "The word '#{@word}' is an English word: #{dictionary?(@word)}."
  end

  def dictionary?(word)
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    return word["found"]
  end
end
