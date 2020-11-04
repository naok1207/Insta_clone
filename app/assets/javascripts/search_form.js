$(function() {
  var input = $('#search_input');
  var submit = $('#search_submit');
  var href = '/posts/search?body=';
  input.on('input', function(event) {
    var value = input.val();
    submit.attr('href', href + value);
    console.log(value);
  });
}); 