App.Controller.landing = function(){

  var $page = $(this);

  $page.append(App.View.make('landing'));

  $page.find('[data-elasticsearch]').each(function(){

    var $region = $(this),

        request = JSON.parse($region.attr('data-elasticsearch')),

        renderRegion = function(apps, textStatus, jqXHR){
          $ul = $(document.createElement('ul'))
          $.each(apps, function(){
            $(document.createElement('li')).html(JSON.stringify(this)).appendTo($ul)
          })
          $region.html($ul);
        },

        throwError = function(jqXHR, textStatus, errorThrown){
          console.error(errorThrown)
        }

    request.fields = ['identity','attributes']; // TODO: figure out why this isn't working

    Engine.Search.elasticsearch({
      request: request,
      success: renderRegion,
      error: throwError
    })
  })

}