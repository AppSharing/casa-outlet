Engine.Search = {

  __base__: function(suffix, options){

    if(!suffix) suffix = '';

    options = {
      type: 'GET',
      url: Engine.Route.to('/local/payloads'+suffix),
      accepts: 'application/json',
      crossDomain: true,
      success: options.success,
      error: options.error
    };

    if(options.request){
      options.contentType = 'application/json';
      options.data = options.request;
      options.dataType = 'json';
    }

    $.ajax(options);

  }

}