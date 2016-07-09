---
layout: project
github: https://github.com/zacscodingclub/beer-me
demo: http://www.youtube.com/watch?v=p48-bVaSB9w
title: "Displaying ActiveRecord Errors in Views"
---

If you ever build even a simple web application, one thing you'll have to figure out is how to display error messages to a user.  My experience with errors has mostly been within the context of using Ruby on Rails and ActiveRecord, specifically validations. [ActiveRecord Validations](http://guides.rubyonrails.org/active_record_validations.html) are a bunch of helper methods which ensure that "bad" data doesn't make it into a database.  As a programmer, I can even create my own custom validations which may have specific logic associated with them.  That is kind of a simplification, as the ActiveRecord Validations are just a smaller part of the complete ORM which seems like Rails magic.

Under the hood of ActiveRecord Validations is a class called `ActivRecordError`, which inherits from the `StandardError` class. The way we access those errors as a programmer is through the resource or model we're trying to create.  For example, if we have a Ruby class which inherits from ActiveRecord, we can first find out if we have any errors by calling `#valid` on the instance of the class.  

```ruby
  class User < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true
  end

  @user = User.new
  @user.valid? # => false
  # or
  @user.invalid? # => true

  # Now, if we know that this instance of the User class is not valid, it's very easy to access the whole ActiveRecord errors object by simply typing:
  @user.errors

  => #<ActiveModel::Errors:0x007fdd5b2248f0 @base=#<User id: nil, name: nil>, @messages={:name=>["can't be blank"]}>

  # But we don't want that, we just want the messages.

  @user.errors.messages
  => #{:name=>["can't be blank"]
```

This return value is a hash in which each key is object's attribute and the value is an array of strings.  This is really helpful because it would not be difficult to iterate over each key-value pair in this hash and output a string. Instead of having to figure that all out though, Rails provides us a little magic and we can use `@user.errors.full_messages` to construct those error messages and return them as an array, like this:

```ruby
  @user.errors.full_messages
  => ["Name can't be blank"]
```

That's awesome!  Now we have a very handy way to access any errors on objects that may exist in our application.  For the rest of the blog, I'm going to get more specific into how I dealt with errors in my most recent application [Beer Me](https://github.com/zacscodingclub/beer-me).  This application is pretty simple and only has three models: User, Beer, and CheckIn.  A user has many check ins and has many beers through check ins, the opposite is true of a beer that has many check ins and many users through check ins, and finally a check in belongs to a user and belongs to a beer.  The code below show the specific validations I have in place for each class. These are not complex validations and they really don't have to be.  They just need to be in place to ensure data integrity.


```ruby
  class User < ActiveRecord::Base
    validates :username, presence: true, uniqueness: true
    validates :first_name, presence: true
    validates :last_name, presence: true

    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    devise :database_authenticatable, :registerable, :trackable,
           :validatable,:omniauthable, :omniauth_providers => [:facebook]
  end
  ...
  class Beer < ActiveRecord::Base
    validates :name, presence: true, uniqueness: true
    validates :brewery, presence: true
    validates :style, presence: true
  end
  ...
  class CheckIn < ActiveRecord::Base
    validates :beer_id, presence: true
    validates :rating, presence: true, inclusion: 0..10
  end
```

For the User class, I included all the [Devise macros](https://github.com/plataformatec/devise) since they provide some validations as well.  

Now since we have all these validations in place and I earlier broke down the data type and structure of an ActiveRecord error, I can now show you a very simple way to display them within the view.  I hinted at these steps earlier, so hopefully they will be easy to remember.  First thing you want to do is check to see if the object is valid, if it isn't, then you can create an unordered with HTML and iterate through each of the `.full_messages`, adding the full message as list items. See example:

```html
  <% if @user.invalid? %>
    <ul>
      <% @user.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
    </ul>
  <% end %>
```
Now we should have validations and users in place!  Unfortunately though, I'm using the [Bootstrap Framework](http://getbootstrap.com) and these errors look a little plain.  In the next code sample, I am simply adding some stuff to the previous code.  First thing to note is p-tag on line 4.  This uses the Rails Inflector to determine if the word "error" should be plural depending on the number of errors object, and adds a nice little header message to the error.  The other additions to this version are some Bootstrap alert classes to make these messages really stand out to the user.  And lastly on line 3, this simply shows a "x" which the user can click to close the error message box.

```html
  <% if @user.valid? %>
    <div class="alert alert-error alert-danger">
      <button type="button" class="close" data-dismiss="alert">x</button>
      <p><%= pluralize(@user.errors.count, "error") %> stopped us from adding this to the database.</p>

      <ul>
        <% @user.errors.full_messages.each do |message| %>
          <li><%= message %></li>
        <% end %>
      </ul>
    </div>
  <% end %>
```
At this point, I would be pretty happy with myself and call it a day.  The problem is I have three different classes and multiple different forms, which means I would need to repeat this code at least three times in the User#new, Beer#new, and CheckIn#new pages.  This of course violates the DRY principle (Don't Repeat Yourself!!!)  Luckily, Rails gives us several ways to refactor this code and I'm going to use an ActionView helper to show these errors wherever I want on my application.

So basically the HTML for all these errors looks the same, except for the instance variable on which we are checking for errors.  One concept that's already used in Rails is the idea of a resource.  This concept is used by Rails generators when creating new models, controllers, views, routes, and tests for that resource.  I think using that concept of a resource is a great abstraction for the models in my application.  Below is the final helper method I ended up creating and there are comments for each line.

```ruby
module ApplicationHelper
  def resource_error_messages(resource)
    # check to see if the resource doesn't exist or if there are no errors
    no_errors = resource.nil? || resource.errors.empty?
    # if there are no errors, this helper stops and returns an empty string, which adds nothing to the view
    return '' if no_errors

    # Similar to above where I am counting the errors, pluralizing if needed, and saving this string as a variable for later use
    num_errors = pluralize(resource.errors.full_messages.count, "error") + " stopped us from adding this to the database."
    # This returns a bunch of list elements with the full message as the text, and then joins them together to create a single string
    # i.e. "<li>Name can't be blank</li><li>Name is too short (minimum is 3 characters)</li>"
    messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join

    # Here we're creating a html heredoc which interpolates the values we created above into a nicely formatted.
    # Note the button_tag which took a lot of figuring out how to nest the dismiss attribute within the data hash to work properly
    content = <<-HTML
      #{ content_tag :p, num_errors}
      #{ button_tag "x", class:"close", data: { dismiss:"alert"} }
      #{ messages}
    HTML

    # This takes the content html we just created and then adds it to a larger div with the correct bootstrap classes
    html = <<-HTML
      #{ content_tag :div, content, class:"alert alert-error alert-danger" }
    HTML

    # Here we take that html variable, and use the .html_safe command to ensure that any unwanted characters are escaped by rails before rendering.  It's may not be too useful for this particular purpose, but this is a good practice to follow.
    html.html_safe
  end
end
```
Now that the helper exists, we can now call it in views simply by typing `<%= resource_error_messages(resource) %>`.
Hopefully there was something of value for you above.  In the video below I give a tour of the user interface and show some interesting portions of the code.  If you're curious about the code, check out the github repo [beer-me](https://github.com/zacscodingclub/beer-me).


[![Beer Me Walkthrough Video](http://img.youtube.com/vi/p48-bVaSB9w/0.jpg)](http://www.youtube.com/watch?v=p48-bVaSB9w)
