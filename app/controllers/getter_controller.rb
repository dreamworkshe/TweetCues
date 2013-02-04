require 'twitter'

class GetterController < ApplicationController
  def get
    word = params[:word]
    freq = Hash.new()
    Twitter.search(word, :count => 100, :result_type => "recent", :lang => "en").results.map do |status|
      #puts status.text
      tokens = status.text.split(/\W+/)
      tokens.each do |t|
        if freq.has_key?(t)
          freq[t] += 1
        else
          freq[t] = 1
        end
      end
    end
    freq = freq.sort_by {|key, value| -value}
    freq_pair = freq.map do |pair|
      {:word => pair[0], :count => pair[1]}
    end
    #@res = freq_pair.to_json
    render :json => freq_pair
  end

  def show
  end
end
