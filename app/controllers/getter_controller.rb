require 'twitter'

class GetterController < ApplicationController
  @@stop_words = ['a','able','about','across','after','all','almost','also','am','among','an','and','any','are','as','at','be','because','been','but','by','can','cannot','could','dear','did','do','does','either','else','ever','every','for','from','get','got','had','has','have','he','her','hers','him','his','how','however','i','if','in','into','is','it','its','just','least','let','like','likely','may','me','might','most','must','my','neither','no','nor','not','of','off','often','on','only','or','other','our','own','rather','said','say','says','she','should','since','so','some','than','that','the','their','them','then','there','these','they','this','tis','to','too','twas','us','wants','was','we','were','what','when','where','which','while','who','whom','why','will','with','would','yet','you','your']
  def get
    word = params[:word].downcase
    freq = Hash.new()
    Twitter.search(word, :count => 250, :result_type => "recent", :lang => "en").results.map do |status|
      #puts status.text
      tokens = status.text.downcase.split(/\W+/)
      tokens.each do |t|
        if freq.has_key?(t)
          freq[t] += 1
        else
          freq[t] = 1
        end
      end
    end

    # delete http
    if freq.has_key? 'http'
      freq.delete('http')
    end

    # delete search word
    if freq.has_key? word
      freq.delete(word)
    end

    # delete retweet
    if freq.has_key? 'rt'
      freq.delete('rt')
    end

    # delete stopwords
    @@stop_words.each do |sw|
      if freq.has_key? sw
        freq.delete(sw)
      end
    end
    freq = freq.sort_by {|key, value| -value}
    freq_pair = freq.map do |pair|
      {:word => pair[0].upcase, :count => pair[1]}
    end
    render :json => freq_pair
  end

  def show
  end
end
