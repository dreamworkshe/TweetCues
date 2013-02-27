function initShow() {
  var spinner;
  var request, running = false;

  var search = function() {
    if (running) {
      request.abort();
    }
    running = true;
    //$("#wordcloud").attr("disabled", "disabled");
    $("#wordcloud").empty();
    var word = $("#search_word").val();
    request = $.getJSON("/get", {word: word}, function(data) {
      var freq = [];
      // $.each(data, function(index, pair) {
      //   freq.push({text: pair.word, weight: pair.count});
      // });
      for (var i = 0; i < data.length && i < 100; i++) {
        freq.push({ text: data[i].word, weight: data[i].count,
          html: { draggable: "true" }, handlers: { click:clickWord } });
      }
      $("#wordcloud").jQCloud(freq,
        { width: 700, height: 400,
          afterCloudRender: function() { running = false; } });
    });
  };

  var clickWord = function() {
    if (running) {
      return;
    }
    var new_search_word = $(this).text();
    new_search_word = new_search_word.substring(0,1) +
      new_search_word.substring(1,new_search_word.length).toLowerCase();
    $("#search_word").val(new_search_word);
    search();
  }

  $("#search_button").click(search);

  $("#search_word").keypress(function(event) {
    if (event.which == 13) {
      search();
    }
  });


};


// jQuery plugin for spin.js
$.fn.spin = function(opts) {
  this.each(function() {
    var $this = $(this),
        data = $this.data();

    if (data.spinner) {
      data.spinner.stop();
      delete data.spinner;
    }
    if (opts !== false) {
      data.spinner = new Spinner($.extend({color: $this.css('color')}, opts)).spin(this);
    }
  });
  return this;
};