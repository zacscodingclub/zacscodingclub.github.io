---
layout: project
github: https://github.com/zacscodingclub/closest_weightlifting_gem
demo: http://www.youtube.com/watch?v=S3jWSZqWviI
title: "Finding a Weightlifting Gym Using a Ruby Gem!"
---

As a student of Flatiron School's online campus, [Learn Verified](https://learn.co/with/zacscodingclub), the first real project you set forth alone to create is a Ruby Gem.  There are several basic requirements to complete this project which include a few things like building a command line interface for the gem and data for the gem must be provided via scraping or public API.  In this post I'm going to talk about how I decided what to make and the basic structure of my program.  Then at the end I'll post a video walkthrough to show the interface and some code.  

A lot of people have an issue coming up with an idea for what they should create.  To get through that barrier, I recommend thinking about the 3 or 4 things in your life that you spend the most time doing. For me that's simple because my time is occupied mostly by working, studying code, and weightlifting.  I picked weightlifting since I know a lot about it and it's fun! Since it's not likely to find any sort of public API regarding weightlifting (email me if you find any though!), I had to figure out some data I could scrape.

After looking through the [USA Weightlifting](http://usaweightlifting.com) website for a little bit, I identified two pieces of relevant content that I could scrape.  The first collection of items I saw were weightlifting events.  These events typically have dates, participants, results, judges, etc.  The second set of data I noticed was the listings of USA Weightlifting certified club gyms [http://www.teamusa.org/usa-weightlifting/clubs-lwc/find-a-club](http://www.teamusa.org/usa-weightlifting/clubs-lwc/find-a-club).  The gyms stood out to me because the page is setup in a very unfriendly manner where the user can only look at gyms by selecting the state in which they are located.  There is no search or other easy lookup method, like a map.

Now that I identified what I was going to scrape, I had to figure out what are the important details of a gym.  To determine those details, I just click through to any state and examine what the webpage tells me about each gym.  Hmmm, OK.  It looks like each Gym will have several attributes which include: name, full address, phone number, director name, and director phone number.

I use [Bundler](http://bundler.io/) (a cool program that manages Ruby gems), so creating a gem from scratch is as easy as typing
```bash
bundle gem closest_weightlifting_gem
```
This is a handy macro that builds out a basic skeleton of folders and files that is commonly used for a Ruby gems.  If you're new to Ruby or gems, I highly recommend you read through this helpful tutorial [RubyGems- Make Your Own Gem](http://guides.rubygems.org/make-your-own-gem/).  After that, you'll what to look through each file and folder and try to figure out what's going on under the hood, so to speak.  Understanding what is inside each gem and where it's located within the code base will make you a more productive programmer.  Below is a screenshot of all the files of the current version of my app:

<img src="/images/cli_file_structure.png" height="850" width="425" />

Starting at the top, the first thing I see is the `/bin` folder.  This holds any executables your program will need to run.  One thing to notice is that there is no file extension on any of the three files within `/bin`.  When first creating these files, I had to modify their permissions using `chmod -R 0777 bin/setup` in the command line to make this file executable.  So now the terminal can run this file, but I also need to add this small bit of code on the first line so that it knows to use the Ruby interpreter when reading the code contained within each file `#!/usr/bin/env ruby`.  Now I can write plain old Ruby syntax within each file and it will work the way I expect!  The three files within `/bin` all serve one particular function: `closest-weightlifting-gem`: command line interface executable, `console`: opens up a [pry console](https://github.com/pry/pry) with some data collected to test,  and `setup`: basic i and installation of proper dependencies.  

The next folder, `/lib`, contains one folder with several files and a file called `closest_weightlifting_gem.rb`.  This requires all the needed dependencies and then creates a `module` with the common namespace that all the files in this program will share: `ClosestWeightliftingGem`.  Within the folder are several files and each one represents a specific class that logically separates the concerns of the program.  I don't really want to get bogged down into the details for each of those files jobs here, but you should know that each file does something simple and hopefully does it well.  The `version.rb` file is a gem standard and should be in every Ruby gem.

After that, there is a `/spec` folder which is used to hold tests for Ruby's rspec testing suite.  The `spec_helper.rb` file contains setup instructions for testing and the other file should contain tests for your program.  I'm slacking on this right now, but it is on my to-do list.

Now there are several files left in the main folder of the gem and they provide two pieces of info needed, one for Github and the other is administration of the gem.

* **Github** - Several files are there since this is also a [Github repository](https://github.com/zacscodingclub/closest_weightlifting_gem), such as `.gitignore`, `LICENSE.txt`, `README.md`, and `notes.md`.  `.gitignore` allows me to pick which files I don't want git to track (see this guide for syntax questions: [Some common .gitignore configurations](https://gist.github.com/octocat/9257657)).  `LICENSE.txt` was generated with the bundle gem command earlier and places a MIT license within this repo gives permission for other collaborators.  `README.md` includes basic installation/setup of the gem, as well as a to-do list for future gem work.  And `notes.md` was just some notes I was keeping throughout the process of making the app.  

* **Gem Administration** - The first thing I typically look at for Ruby gem info is the `gemspec` file, but in an actual gem, it just refers the user to the code in the `closest_weightlifting_gem.gemspec` file.  The .gemspec file pieces all the information needed for this gem to run.  It provides basic biographical info about the gem and it's where I have to include the commands which add dependencies to the code. Other gem admin related files end with `.gem` and they provide a record of each version of the gem.

* **Other** - `.rspec` includes code which customizes the rspec command line code, whether it be format, color, output, etc.  I typically use the `Rakefile` to define tasks which I would use regularly during development.  In this case, I put that into the `/bin/console` executable.  And the last file is the `.travis.yml` and I had to look that one up.  According to [Travis CI - Wikipedia](https://en.wikipedia.org/wiki/Travis_CI), "This file specifies the programming language used, the desired building and testing environment (including dependencies which must be installed before the software can be built and tested), and various other parameters." So it sounds like a basic configuration file, but to be honest, I've never seen the code inside it until just now.  


Well, with all that said, in the video below I give a tour of the user interface and show some interesting portions of the code.  If you're curious about the code, check out the github repo [closest_weightlifting_gem](https://github.com/zacscodingclub/closest_weightlifting_gem).


[![Closest Weightlifting Gem Gym Walkthrough Video](http://img.youtube.com/vi/S3jWSZqWviI/0.jpg)](http://www.youtube.com/watch?v=S3jWSZqWviI)
