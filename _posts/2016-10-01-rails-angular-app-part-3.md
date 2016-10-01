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
          .then(function(response)) {
            ctrl.products = response.data;
          }, function(error) {
            console.log('Error occurred: ' + error);
          }
    }
  });
```

First we
