require 'open-uri'

class GamesController < ApplicationController
  def new
    @letters = Array.new(10) { ('A'..'Z').to_a.sample }
  end

  def score
    @word = params[:word]
    @letters = params[:letters]
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    outcome_serialized = URI.open(url).read
    outcome = JSON.parse(outcome_serialized)
    @result = {}
    score = result(@word.upcase, @letters, outcome)
    @result[:score] = score[0]
    @result[:message] = score[1]
  end

  private

  def result(attempt, letters, outcome)
    if outcome['found'] && valid_word?(attempt, letters)
      score = [compute_score(attempt), 'well done']
    elsif outcome['found'] && !valid_word?(attempt, letters)
      score = [0, 'not in the grid']
    else
      score = [0, 'not an english word']
    end
    score
  end

  def compute_score(attempt)
    attempt.size * 10
  end

  def valid_word?(word, letters)
    word.chars.all? { |char| word.count(char) <= letters.count(char) }
  end
end
