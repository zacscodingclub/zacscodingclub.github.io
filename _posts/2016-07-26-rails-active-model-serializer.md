---
layout: project
github: https://github.com/zacscodingclub/beer-me
demo: http://www.youtube.com/watch?v=n1HEZfjsTMo
title: "jQuery AJAX with Rails"
---

In the [last blog post](http://zacscodingclub.github.io/display-errors-rails-activerecord-errors/), I talked about building a basic Rails app and some of the things I learned along the way.  Today, I'm going to look at what happened along the way when I added a few AJAXy things to that app.

Getting started with AJAX on a Rails app can be a bit confusing, but once you learn a few things, it should be easier to figure stuff out.  One of the first things to know is that Ruby is going to return a string of HTML with it's standard setup.  To get going, I added the [active_model_serializer](https://github.com/rails-api/active_model_serializers) gem to my project using the instructions in the repo.  This will add another generator to Rails which I could call using `rails generate serializer beer`.  This creates a new file ([beer_serializer.rb](https://github.com/zacscodingclub/beer-me/blob/34d4ebc71d2d485ec276e8e30e3bc8da916e3a8b/app/serializers/beer_serializer.rb)) and inside this file is a new class which inherits from `ActiveModel::Serializer`.  The second line of this class shows which attributes of a Beer will be converted into JSON.  Each of these attributes becomes a key in the serialized message and the value is set either from a form or a database request. The id attribute is added by default when you use the Rails generator. For example, the BeerSerializer class would create a nicely formatted object like this:

```javascript
  {
    "id": "1",
    "name": "Bomb",
    "style": "Imperial Stout",
    "brewery": "Prairie"
  }
```
Knowing that the objects return from serialization in this consistent format really helps me save time later.  There are other ways to get to this point, but this is very simple and requires

So with active model serializer in place, everything works right?!?  Well not exactly, at this point the Rails application is still going to return a string of HTML for each request.  To change that, we need to change some code in the BeersController.  Below are three examples of controller actions and what a developer should expect from these actions.

```ruby
  # This is the basic Rails controller action.  This grabs some data out of the
  # databas and then defaults to rendering the index view in the beers folder.
  class BeersController < ApplicationController
    def index
      @beers = Beer.all
    end
  end

  # Very similar to the one above, BUT (and it's a huge but)
  # this will only return JSON!
  class BeersController < ApplicationController
    def index
      @beers = Beer.all

      render json: @beers
    end
  end

  # And finally, this is a more adaptable controller action which is like what I
  # used in the project.  This calls a respond_to block passing in the format of
  # the web request, so if the request was simply 'beers/index', it would
  # return HTML.  However, if the request was 'beers/index.json', this will
  # return JSON similar to what I showed above.
  class BeersController < ApplicationController
    def index
      @beers = Beer.all

      respond_to do |f|
        f.html { render :index }
        f.json { render json: @beers }
      end
    end
  end
```
This concept can be applied throughout all of the actions within the BeersController to create a RESTful API.  

Now that the back end is setup, we can finally use jQuery to add some AJAX functionality.  Since I only provided one API endpoint in the example above, I'll show a simple HTTP Get request.  With the correct controller code, it is very easy to make this code extend to all the other HTTP requests as well.  Check out the official documentation for jQuery [$.ajax](http://api.jquery.com/jquery.ajax/) for more information.

```javascript
  function getBeers() {
    $.get('/beers' + '.json', function(data) {
      // whatever you want to happen after a request
      processBeers(data);
    });
  }
```
This is a very basic request which has two parameters.  The first is a route and the second is a callback function. In this example, we have an anonymous callback function with the response being the argument.  This response is a variable called data and is a JSON object! There are a few other options which can be chained on to a [$.get request](https://api.jquery.com/jquery.get/), which include .done, .fail, and .always, so go check them out.  Now that we are getting a JSON object as a response, we can pass that data into another function which has been created to handle the display portion of the request.

In this blog, I just showed one simple example, but this technique can be translated all throughout a Rails apps controller actions.  In fact, I can create an entire CRUD API using these methods!  In the future, I'll go delve deeper into creating a more amazing API and using Angular on the front end!


[![Beer Me - Rails App with Added AJAX!! ](http://img.youtube.com/vi/sbhN0W47CSg/0.jpg)](http://www.youtube.com/watch?v=n1HEZfjsTMo)
