function initShow() {
  var search = function() {
    $("#wordcloud").empty();
    var word = $("#search_word").val();
    $.getJSON("/get", {word: word}, function(data) {
      var freq = [];
      // $.each(data, function(index, pair) {
      //   freq.push({text: pair.word, weight: pair.count});
      // });
      for (var i = 0; i < data.length && i < 100; i++) {
        freq.push({text: data[i].word, weight: data[i].count});
      }
      $("#wordcloud").jQCloud(freq, {width: 700, height: 400});
    });
  };

  $("#search_button").click(search);
  $("#search_word").keypress(function(event) {
    if (event.which == 13) {
      search();
    }
  });


};