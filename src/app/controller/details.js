App.Controller.Details = {

  attachTo: function(region){

    var $region = $(region);

    $region.click(function(){

      $('main > *').hide();

      $('main').prepend(App.View.make('app-details', {
        "app":JSON.parse($region.attr('data-app-details'))
      }));

      $('main .app-details [data-action="close"]').click(function(e){
        e.preventDefault();
        $(this).closest('.app-details').remove();
        $('main > *').show();
      })

    })

  }

}