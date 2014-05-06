App = {

  Persistence: {
    type: false,
    options: {}
  },

  start: function(){

    var type, options;

    if(type = getQueryParameter('type')){
      sessionStorage.setItem('type', type);
      if(options = getQueryParameter(type)){
        sessionStorage.setItem('options', decodeURIComponent(options));
      }
    }

    if(type = sessionStorage.getItem('type')){
      App.Persistence.type = type;
      if(options = sessionStorage.getItem('options')){
        App.Persistence.options = JSON.parse(options);
      }
    }

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

  Controller: {},

  Handler: {}

};