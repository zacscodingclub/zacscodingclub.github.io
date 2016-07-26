---
layout: project
github: https://github.com/zacscodingclub/beer-me
demo: http://www.youtube.com/watch?v=n1HEZfjsTMo
title: "jQuery AJAX with Rails"
---

In the [last blog post](http://zacscodingclub.github.io/display-errors-rails-activerecord-errors/), I talked about building a basic Rails app and some of the things I learned along the way.  Today, I'm going to look at what happened along the way when I added a few AJAXy things to that app.

Getting started with AJAX on a Rails app can be a bit confusing, but once you learn a few things, it should be easier to figure stuff out.  One of the first things to know is that Ruby is going to return a string of HTML with it's standard setup.  To get going, I added the [active_model_serializer](https://github.com/rails-api/active_model_serializers) gem to my project using the instructions in the repo.  This will add another generator to Rails which I could call using `rails generate serializer beer`.  This creates a new file (beer_serializer.rb) and inside this file is a new class which inherits from `ActiveModel::Serializer`.  The second line of this class tells the interpreter which attributes of a Beer will be converted into JSON.  Each of these attributes becomes a key in the serialized message and the id is filled in by  default. For example, the BeerSerializer class would create a nicely formatted object like this:

```javascript
  {
    "id": "1",
    "name": "Bomb",
    "style": "Imperial Stout",
    "brewery": "Prairie"
  }
```


[![Beer Me - Rails App with Added AJAX!! ](http://img.youtube.com/vi/sbhN0W47CSg/0.jpg)](http://www.youtube.com/watch?v=n1HEZfjsTMo)
