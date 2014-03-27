App.Controller.Details = {

  attachTo: function(region){

    var $region = $(region), detailsJsonString = $region.attr('data-app-details');

    $region.click(function(){

      $('main > *').hide();

      $('main').prepend(App.View.make('app-details', {
        "app":JSON.parse(detailsJsonString)
      }));

      $('main .app-details [data-action="close"]').click(function(e){
        e.preventDefault();
        $(this).closest('.app-details').remove();
        $('main > *').show();
      });

      $('main .app-details .add-app-button').click(function(e){
        e.preventDefault();
        switch(App.Persistence.type){
          case 'lti':
            var $form = $(document.createElement('form'))
              .attr('action', App.Persistence.options['return'])
              .attr('method', 'POST')
              .hide();
            $(document.createElement('textarea'))
              .attr('name', 'app')
              .html(detailsJsonString)
              .appendTo($form);
            $('body').append($form);
            $form.submit();
            break;
          default:
            console.error('Undefined App.Persistence.type -- do not know how to add')
        }
      });

    })

  }

}