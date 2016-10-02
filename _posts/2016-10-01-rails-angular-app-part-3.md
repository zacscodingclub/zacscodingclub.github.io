---
layout: post
title: "Building an Angular Application on a Rails Backend: Part 3"
---

This is the third of a three part series about the insights I gained while building my first AngularJS application using Ruby on Rails in the back-end. This particular post is about setting up the front-end templates and interacting with the Rails back end using Angular factories. There are almost certainly better ways to do some of these things, but this is how I did it and what I learned.

<hr>

After the last [blog post](http://zacscodingclub.github.io/rails-angular-app-part-2/), I have a basic Rails application back end with a basic Angular controller in place.  At this point, the only data that exists within this controller is just a simple string variable put in place to test that there aren't any errors with the setup.

The first step to complete is to include the modules we need in `app.js`.  This can be accomplished in a couple steps.  First, since we're using Rails, one of the needed modules can be packed into the application by adding `gem 'angular-rails-templates'` to the Gemfile and running `bundle install`. For the other two needed modules, I need to download the actual source code and save that into the `app/assets/javascripts` directory.  The modules I need to obtain are [ui.router](https://github.com/angular-ui/ui-router) and [ngMessages](https://docs.angularjs.org/api/ngMessages/directive/ngMessages).  As with any javascript files in Rails, I need to add all of those modules to the [Asset Pipeline](http://guides.rubyonrails.org/asset_pipeline.html) as well by making sure to add the following lines to the `application.js` file:

```javascript
//= require angular-ui-router
//= require angular-resource
//= require angular-rails-templates
```

Finally I can add each module to the initialization of the angular app in `app.js` using the second bit of code below:

```javascript
  // Previous code
  angular
    .module('trackazon', []);

  // New code with modules added
  angular
    .module('trackazon', ['ui.router', 'templates', 'ngMessages'])
```
It's simple to determine if any errors have been made by starting up the server using `rails s`, load the page in a browser, then check the browser's console.  



With no errors, I need to create a route and wire it up to a template and controller.

```javascript
  angular
    .module('app', ['ui.router', 'templates', 'ngMessages'])
    .config(function($stateProvider, $urlRouterProvider) {
      $stateProvider
        .state('inventory', {
          url: '/',
          templateUrl: 'products/index.html',
          controller: 'InventoryController as vm'
        })

    $urlRouterProvider.otherwise('/');
    });
```
Here we have drawn a route called `inventory` which is mapped to the url '/'.  Since Angular will add a hashtag (#) to the end of the URL, this inventory route having a url of '/' means that the URL in the browser will end with `#/`.  This route also has defined a template called 'products/index.html', which means I need to create a directory within `app/assets/javascripts/` called 'products' and an 'index.html' file inside that new directory.

Also, since I set the controller for this route to 'InventoryController', I need to build a controller action which will kick off a process to access the products in the database.  We already have this controller from the previous sections, but some stuff needs to be updated.

```javascript
angular
  .module('trackazon')
  .controller('InventoryController', function($scope) {
    var ctrl = this;

    ctrl.products = [];

    ctrl.getProducts = function() {
      ProductService.getProducts()
          .then(function(response) {
            ctrl.products = response.data;
          }, function(error) {
            console.log("Error occurred: " + error);
          })
      }
    });
```
Alright, so what just happened there is I set a variable `ctrl` equal to the InventoryController so it's easier to understand what scope I'm in later in the controller.  Next I set a controller variable `products` equal to an empty array so I can have a structure to hold data in later.  Lastly I make a function whose job is to go out and get the products data from the database.  But wait, you may notice that I used something called `ProductService`, which I haven't explained yet.

A service in Angular is a great way to extract interaction with a database or external source into it's own home.  In this case, the `ProductService` will simply interact with the local database we created using Rails.  Creating a service is fairly straightforward as you can see in the code below:

```javascript
  angular
    .module('trackazon')
    .service('ProductService',['$http', function($http) {
      this.getProducts = function() {
        return $http.get('/products.json');
      }
    }]);
```
With this code in place, our controller will now have all the products inside the variable `ctrl.products`.  So how do we display this?  Well, since we set the templateUrl in the application router, we need to create that file.  So, now I go ahead and make a file called `index.html` located inside the `app/assets/javascripts/templates/products` directory.  Next, I need to edit that `index.html` file to display some of the product attributes.

```html
  <ul ng-controller="inventory">
    <li ng-repeat="product in inventory.products" id="{{ product.id }}" name="product.name">
      {{ product.name }}, {{ product.item_price }}, {{ product.quantity }}
    </li>
  </ul>
```

Since I already mounted the application to the html element, I needed to go ahead and declare which controller I'm using with the `ng-controller` directive.  With this defined, the `products/index.html` file will be loaded into the browser DOM. The HTML in the example above uses an Angular directive [ng-repeat](https://docs.angularjs.org/api/ng/directive/ngRepeat) which will iterate through all the items in a collection.  In this case, it is goes through all the products and makes an instance variable `product` which allows me to access various attributes which I can display on the page.

Now that everything is working and displaying on the page, it's time to conclude this series.  I hope you learned something, because I know I learned a lot while trying to explain how to create and Angular application.  
