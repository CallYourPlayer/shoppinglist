$(document).ready(function(){

  $(document).bind('ajaxError', 'form#new_item', function(event, jqxhr, settings, exception){

    // note: jqxhr.responseJSON undefined, parsing responseText instead
    $(event.data).render_form_errors( $.parseJSON(jqxhr.responseText) );

  });

  var nav = document.getElementById('navlist');

    function toggleNav() {       
      if ( nav.style.display === "" )
        nav.style.display = "block";

      else
        nav.style.display = "";
    }


    function windowResizeHandler () {
      if ( screen.width > 500 )
        nav.style.display = "";
    }

    window.addEventListener("resize", windowResizeHandler);

  $("input[name='period']").click(function(){
    if ($(this).val() == '1' || $(this).val() == '2' || $(this).val() == '3') {
      $('#form_search_dates').hide();
      var elem = $('#my-form')[0];
      $(elem).submit();
      //Rails.fire(elem, 'submit');
      //this.closest('form').submit();
    } 
    else {
      $('#form_search_dates').show();
    }
  });

  var period = urlParam('period');
  var date = urlParam('date_start');
  if (period) {
    $("#period_" + period).attr("checked", true);
  }
  if (date) {
    $("#period_4").attr("checked", true).trigger('click');
  }
});

function urlParam(name){
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results==null) {
       return null;
    }
    return decodeURI(results[1]) || 0;
}

(function($) {

  $.fn.modal_success = function(){
    // close modal
    this.modal('hide');

    // clear form input elements
    // todo/note: handle textarea, select, etc
    this.find('form input[type="text"]').val('');

    // clear error state
    this.clear_previous_errors();
  };

  $.fn.render_form_errors = function(errors){

    $form = this;
    this.clear_previous_errors();
    model = this.data('model');

    // show error messages in input form-group help-block
    $.each(errors, function(field, messages){
      $input = $('input[name="' + model + '[' + field + ']"]');
      $input.closest('.form-group').addClass('has-error').find('.help-block').html( messages.join(' & ') );
    });

  };

  $.fn.clear_previous_errors = function(){
    $('.form-group.has-error', this).each(function(){
      $('.help-block', $(this)).html('');
      $(this).removeClass('has-error');
    });
  }

}(jQuery));