App.Controller.SearchCollection = {

  attachTo: function(region){

    var $region = $(region),

      request = JSON.parse($region.attr('data-'+Engine.Config.Search.type)),
      viewName = $region.attr('data-collection-view'),

      renderRegion = function(apps, textStatus, jqXHR){
        $region.html(App.View.make('collection/'+viewName, {"apps":apps}));
      },

      throwError = function(jqXHR, textStatus, errorThrown){
        console.error(errorThrown)
      }

    request._source = ['identity','attributes'];

    Engine.Search.elasticsearch({
      request: request,
      success: renderRegion,
      error: throwError
    })

  }

}