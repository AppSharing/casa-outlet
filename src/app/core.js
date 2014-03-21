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

    App.applyConfigData();

  },

  applyConfigData: function(){

    $('[data-from-config]').each(function(){
      var $this = $(this),
        value = App.Config[$this.attr('data-from-config')];

      if(value)
        $this.html(value)
    })

  },

  View: {

    make: function(name, data){
      return new EJS({url: 'view/'+name+'.ejs'}).render(data ? data : {})
    }

  },

  Controller: {}

};