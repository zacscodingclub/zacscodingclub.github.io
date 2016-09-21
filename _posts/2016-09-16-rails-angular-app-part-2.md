---
layout: post
title: "Building an Angular Application on a Rails Backend: Part 2"
---

This is the second of a three part series about the insights I gained while building my first AngularJS application using Ruby on Rails in the back-end. This particular post is about hooking up Angular to the Rails API. There are almost certainly better ways to do some of these things, but this is how I did it and what I learned.

<hr>

In the last section I provided an example of how a single controller method could respond with JSON data to a request.  Let's pretend that concept was applied to the entire set of controller actions so that I now have a fully functioning CRUD JSON API.  The next steps needed to create an Angular application will be: including the Angular source file, creating and mounting the application, and building a controller.

There are two quick and easy ways to add the AngularJS source file to a Ruby on Rails application.  The first and probably more Rails way is to simply add [AngularJS Ruby gem](https://github.com/hiravgandhi/angularjs-rails) to the Gemfile by adding the line `gem 'angularjs-rails'`. Then you will need to add this line to the application.js file `//= require angular`, located in `app/assets/javascripts`.  Finally, you will have to install it via the command line using Bundler, simply by typing `bundler install` into the prompt.  

The other way requires a visit to [https://angularjs.org/](https://angularjs.org/) to download the actual source file.  Once the file is downloaded, it can be placed in the same directory mentioned above, `app/assets/javascripts`, and then we'll have to require it in the application.js file as well using the same code: `//= require angular`.

With Angular now "installed", the next step is to initialize an Angular app module.  This is accomplished by creating a new file within that same `javascripts` directory called `app.js`.  Now to initialize the app, we need to write some code similar to what's below:

```javascript
angular
  .module('trackazon', []);
```
Here I created an app and the first argument is the name of the app, while the second argument is an array of modules to include in the app.  Since I'm just demonstrating a basic app, I didn't include any modules, but there are tons available which are used regularly and you can find a list of them here (http://ngmodules.org/)[http://ngmodules.org/].

The next step is to mount (or bootstrap) the app to it's root element of the HTML using the directive `ng-app`.  This can be accomplished easily by navigating to the Rails application template file located here: `app/views/application.html.erb`.  Here we're just going to add an attribute to an already existing HTML element.  I typically bootstrap the application to the body attribute like this `<body ng-app="trackazon">`, but I often see it mounted to the HTML element as such: `<HTML ng-app="trackazon">`.






1. Including Angular and mounting the app
2. Building a controller


3. Getting data using a service
