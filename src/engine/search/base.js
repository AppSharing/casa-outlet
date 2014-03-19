Engine.Search = {

  __base__: function(type, options){
    $.ajax($.extend({}, options, {
      type: 'GET',
      url: Engine.Route.to('/local/payloads/_'+type),
      accepts: 'application/json',
      contentType: 'application/json',
      crossDomain: true,
      dataType: 'json',
      body: options.request,
      success: options.success,
      error: options.error
    }));
  }

}