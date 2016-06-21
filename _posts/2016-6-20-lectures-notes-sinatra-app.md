---
layout: project
github: https://github.com/zacscodingclub/learn-progress-checklist
demo: http://www.youtube.com/watch?v=
title: "A Sinatra Application Built to Hold My Lecture Notes"
---

As I continue along the process of becoming a web developer, I am constantly watching videos about various programming concepts.  There are so many lectures, talks, and podcasts now, that it is easy to lose some time not realizing which ones I have already watched or trying to keep my notes straight in order.  Since my last post discussed [my first Ruby gem](http://zacscodingclub.github.io/find-a-gym-gem/), and I'm learning to become a web developer, it makes sense that the next step in my learning would be to create a web application to solve my problem.  My first hack of a solution to this issue is a [Sinatra](http://www.sinatrarb.com/) application I built called [Learn Progress Checklist](https://github.com/zacscodingclub/learn-progress-checklist).

This project was my first crack at building a custom web app and wiring it up with my data.  And what that really means to me is that I learned a lot about ActiveRecord in the process of building this application.  The two main parts of ActiveRecord that I used most frequently were the migrations and validations.  Honestly, I think the Ruby on Rails documentation for [Migrations](http://edgeguides.rubyonrails.org/active_record_migrations.html) and [Validations](http://edgeguides.rubyonrails.org/active_record_validations.html) are amazing!  While troubleshooting the construction of my app, I was constantly referencing back to these guides and learning that I could in fact set column defaults and ensure only the correct data is entering into the database with model validations.  Most of the validations in this app are simple checks to make sure that the data is present as seen in these lines of code from their respective models:
```
class User < ActiveRecord::base
  validates :email, presence: true, uniqueness: true
  ...
end

class Note < ActiveRecord::Base
  validates_presence_of :content
  ...
end
```



Sinatra Controller Actions vs Rails
