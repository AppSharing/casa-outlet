Engine.Search = {

  __base__: function(suffix, options){

    ajaxOptions = {
      type: 'GET',
      url: Engine.Route.to('/local/payloads'+(suffix?suffix:'')),
      accepts: 'application/json',
      crossDomain: true,
      success: options.success,
      error: options.error
    };

    if(options.request){
      ajaxOptions.contentType = 'application/json';
      ajaxOptions.data = 'body='+encodeURIComponent(JSON.stringify(options.request));
      ajaxOptions.dataType = 'json';
    }

    $.ajax(ajaxOptions);


  }

}