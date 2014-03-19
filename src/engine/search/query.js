Engine.Search.query = function(queryString, options){
  Engine.Search.__base__('?query='+encodeURIComponent(queryString), options);
};