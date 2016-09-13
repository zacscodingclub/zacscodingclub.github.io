---
layout: project
github: https://github.com/zacscodingclub/trackazon
demo: http://www.youtube.com/watch?v=n1HEZfjsTMo
title: "Building an Angular Application on a Rails Backend: Part 1"
---

This is the first of a multi-part series about the insights I gained while building my first AngularJS application using Ruby on Rails in the backend.  There are almost certainly better ways to do some of these things, but this is how I did it and what I learned.

<hr>

Building a Ruby on Rails application often involves some "magic", as it's often called.  One piece of this magic is involved with how a controller action automatically knows to render a view that shares the correct folder and name of that action.  For example, if I had a ProductsController with an index action, Rails would look for a file called `index.html.erb` located in a folder named `product` nested within the `app/views` directory.  This works great for a standard application, but if I wanted to add AJAX functionality I would need to find a different method since parsing an html document and sussing out all the needed parts would quickly become overwhelming.

One way to deal with hooking up a front end JavaScript framework to the Rails back end, is to have the controller actions return JSON data and then use JavaScript to parse that data.  Using this method can make it easier to add AJAX functionality without triggering a complete page reload, which makes for a much smoother user experience.  

Let's now go back to that ProductsController I mentioned earlier.  A very simple version of that controller could look like this:

```ruby
  class ProductsController < ApplicationController
    def index
      @products = Product.all
    end

    def show
      @product = Product.find(params[:id])
    end

    def new
      @product = Product.new
    end

    def create
      @product = Product.new(product_params)

      if @product.save
        flash[:success] = "Product created!"
        redirect_to @product
      else
        render 'new'
      end
    end

    def edit
      @product = Product.find(params[:id])
    end

    def update
      @product = Product.find(params[:id])

      if @product.update_attributes(car_params)
        redirect_to @product
      else
        render 'edit'
      end
    end

    def destroy
      Product.find(params[:id]).destroy
      redirect_to products_path
    end

    private
      def product_params
        params.require(:product).permit(:name, :item_price, :sell_price, :quantity)
      end
  end
```
There's nothing too out of the ordinary in there, sure it could be more complex but I'm trying to keep this relatively basic.  Each controller action will return a string of HTML which the browser will then render on the page for the user to view.  

To upgrade this application into a single page app (SPA), I have to change the output of each of those controller actions to return JSON.  The easiest and quickest way to change the output is using the powerful `render` method provided via the [ActionController::Base class](http://guides.rubyonrails.org/layouts_and_rendering.html#using-render).  The `render` method can be used to display a variety of files and file types, such as simple templates, HTML, plain text, XML, and even the coveted JSON.  

For example, looking at the `Products#index` action, it's very simple to change the output like below:

```ruby
  def index
    @products = Product.all

    render json: @products
  end
```
This works great for what we need to setup a SPA, but in order to make the application extremely flexible, it could be valuable to have the controller return multiple file types.  Rails has another method nested inside ActionController called `respond_to` which provides this functionality.  This method will examine the server request and depending on the file type of that request, it will provide a return value of similar filetype.  In the example below, the browser would be provided a response in kind with the request.  So if it was `/products.json`, the response would be JSON; if `/products.xml`, the response XML.

```ruby
  def index
    @products = Products.all

    respond_to do |format|
      format.html { render :index }
      format.json { render json: @products }
      format.xml { render xml: @products }
    end
  end
```
Once again, this provides the functionality to create a SPA already, but while completing my project, I found of another way of metaprogramming the response like below.  This might not be as readable as the above format, it is certainly much more maintanable code since you only have to add the format type as an input to the `.any` block.

```ruby
  def index
    @products = Products.all

    respond_to do |format|
      format.html { render :index }
      format.any(:xml, :json, :text) { render request.format.to_sym => @products }
    end
  end
```
I recommend checking out this  [respond_to](http://apidock.com/rails/ActionController/MimeResponds/respond_to) documentation to learn even more.

In the next segment of this series, I'm going to show how to setup AngularJS on the front end to easily retrieve and display the JSON data.
