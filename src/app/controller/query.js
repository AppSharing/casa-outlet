App.Controller.Query = {

  execute: function(queryString, resultViewName){

    var $region = $(this),

        renderRegion = function(apps, textStatus, jqXHR){
          $region.html(App.View.make('results', {"apps":apps}));
          App.Controller.Query.attachToForm($region.find('form[data-type="query"]'));
        },

        throwError = function(jqXHR, textStatus, errorThrown){
          console.error(errorThrown)
        }

    Engine.Search.query(queryString, {
      success: renderRegion,
      error: throwError
    })

  },

  attachToForm: function(form){

    var $form = $(form);
    $form.submit(function(e){
      e.preventDefault();
      App.execute(
        App.Controller.Query,
        $form.find('[type="search"]').val()
      );
    })

  }

}