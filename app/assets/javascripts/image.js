$(function() {
  var image = $('#edit_image');
  image.on('change', function() {
    var image_ = image.prop('files')[0];
    var reader_ = new FileReader();
    reader_.onload = function() {
      $('#preview').attr('src', reader_.result);
    }
    reader_.readAsDataURL(image_);
  })
})
