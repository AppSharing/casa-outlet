App = {
  start: function(){
    App.execute(App.Controller.landing)
  },
  execute: function(controller){
    var $main = $('main');
    $main.html('');
    controller.call($main);
  },
  View: {
    make: function(name, data){
      return new EJS({url: 'views/'+name+'.ejs'}).render(data ? data : {})
    }
  },
  Controller: {}
};