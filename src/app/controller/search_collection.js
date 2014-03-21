App.Controller.SearchCollection = {

  attachTo: function(region){

    var $region = $(region),

      request = JSON.parse($region.attr('data-'+Engine.Config.Search.type)),
      viewName = $region.attr('data-view'),
      title = $region.attr('data-title')

      renderRegion = function(apps, textStatus, jqXHR){
        $region.append(App.View.make(viewName, {"apps":apps,"title":title}));
        $region.find('[data-app-details]').each(function(){
          App.Controller.Details.attachTo(this);
        })
        $region.find('.scrollable ul:not(.one-line)').each(function(){
          var $this = $(this), width = 0;
          $this.find('> li > *').each(function(){
            width += $(this).outerWidth(true);
          })
          $this.css('width', width);
        });
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