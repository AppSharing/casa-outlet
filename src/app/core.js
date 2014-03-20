App = {

  start: function(){
    App.execute(App.Controller.Landing)
  },

  execute: function(controller){

    var args = Array.prototype.slice.call(arguments),
        controllerClass = args.shift(),
        controllerArgs = args,
        $main = $('main');

    $main.html('');
    controllerClass.execute.apply($main, controllerArgs);

  },

  View: {

    make: function(name, data){
      return new EJS({url: 'views/'+name+'.ejs'}).render(data ? data : {})
    }

  },

  Controller: {}

};