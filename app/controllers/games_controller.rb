class GamesController < ApplicationController
  def new
    letters = ('A'..'Z').to_a
    vowels = %w[A E I O U]
    @random_letters = []
    7.times { @random_letters << letters.sample }
    3.times { @random_letters << vowels.sample }
  end

  def score
    @answer = params['answer']
    @grid = params[:random_letters].split
    @random_letters = params[:random_letters].split
    @score = 0

    url = "https://wagon-dictionary.herokuapp.com/#{@answer}"
    response = RestClient.get(url)
    @data = JSON.parse(response)

    session[:score] ||= 0

    if @data['found'] && found_in?(@answer, @grid)
      @outcome = "Congratulations! #{@answer} is an english word which can be built from #{@random_letters}!"
      @score += @answer.length**2
      session[:score] += @score
    elsif @data['found'] && !found_in?(@answer, @random_letters)
      @outcome = "Uhoh! #{@answer} can't be built from #{@random_letters}!"
    else
      @outcome = "Dafuq!? #{@answer} isn't even a word!"
    end

    # if session[:score]
    #   session[:score] += @score
    # else
    #   session[:score] = @score
    # end

  end

  def found_in?(word, grid)
    word.chars.all? do |letter|
      grid.include? letter
      grid.delete_at(grid.index(letter)) if grid.include? letter
    end
  end

end
