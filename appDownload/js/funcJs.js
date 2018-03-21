$(document).on('click', '.buttonStyle', function () {
  Shiny.onInputChange('last_btn',this.id);
});

$(document).on('click', '.buttonStyleObj', function () {
  Shiny.onInputChange('last_btnObj',this.id);
});

$(document).on('click', '.buttonStyleODS', function () {
  Shiny.onInputChange('last_btnods',this.id);
});

$(document).on('click', '.buttonStyleIcu', function () {
  Shiny.onInputChange('last_btnicu',this.id);
});

$(document).ready(function(){
  $(document).on("click", ".buttonStyle,.buttonStyleObj,.buttonStyleIcu", function(evt) {
	  $(".buttonStyle,.buttonStyleObj,.buttonStyleIcu").css('background-color', '#000');
	    const btnActual = evt.target;
	    const img = $(btnActual).find('.cosa');
	    if (img) {
        $('.cosa').removeClass('inverse');
	      $(img).addClass('inverse');
	    }
	    $(".buttonStyle,.buttonStyleObj,.buttonStyleIcu").css('color', '#00CEF6');
      $(this).css('background-color', '#00CEF6');
      $(this).css('color', '#26327E');
    });
}); 