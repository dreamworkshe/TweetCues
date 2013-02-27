require 'twitter'

class GetterController < ApplicationController
  include GetterHelper
  def get
    word = params[:word].downcase
    freq = Hash.new()
    Twitter.search(word, :count => 300, :result_type => "recent", :lang => "en").results.map do |status|
      #puts status.text
      tokens = status.text.downcase.split(/\W+/)
      tokens.each do |t|
        if t.length <= 3
          next
        end
        if freq.has_key?(t)
          freq[t] += 1
        else
          freq[t] = 1
        end
      end
    end
    
    # delete search word
    word.split(/\W+/).each do |subword|
      if freq.has_key? subword
        freq.delete(subword)
      end
    end

    filter_words(freq)

    freq = freq.sort_by {|key, value| -value}
    freq_pair = freq.map do |pair|
      {:word => pair[0].upcase, :count => pair[1]}
    end
    render :json => freq_pair
  end

  def show
  end
end
