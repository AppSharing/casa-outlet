App.Controller.Landing = {

  execute: function(){

    var $page = $(this);

    $page.append(App.View.make('landing'));

    App.Controller.Query.attachToForm($page.find('form[data-type="query"]'));

    $page.find('[data-type="search"]').each(function(){
      App.Controller.SearchCollection.attachTo(this);
    });

  }

}