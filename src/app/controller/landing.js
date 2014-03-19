App.Controller.landing = function(){

  var $page = $(this);

  $page.append(App.View.make('landing'));

  $page.find('[data-collection-view]').each(function(){

    var $region = $(this),

      request = JSON.parse($region.attr('data-'+Engine.Config.Search.type)),

      viewName = $region.attr('data-collection-view'),

      renderRegion = function(apps, textStatus, jqXHR){
        $region.html(App.View.make('collection/'+viewName, {"apps":apps}));
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