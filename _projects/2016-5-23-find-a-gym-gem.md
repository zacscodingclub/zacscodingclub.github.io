---
layout: project
title: "Find a Gym by Using the Closest Weightlifting Gym Gem!"
---

As a student of Flatiron School's online campus, Learn Verified, the first real project you do alone is to create a Ruby Gem.  There are several basic requirements to complete this project which include a few things like building a command line interface for the gem and data for the gem must be provided via scraping or public API.

A lot of people have an issue coming up with an idea for what they should create.  To get through that barrier, I recommend listing the 3 or 4 things in your life that you spend the most time doing. For me that's simple because my time is occupied mostly by working, studying code, and weightlifting.  I picked weightlifting since I know a lot about it and it's fun! Since it's not likely to find any sort of public API regarding weightlifting ([email me](zbaston@gmail.com) if you find any!), I had to figure out some data I could scrape.

After looking through the [USA Weightlifting](http://usaweightlifting.com) website for a little bit, I identified two pieces of relevant content that I could scrape.  The first collection of items I saw were weightlifting events.  These events typically have participants, results, judges, etc.  The second set of data I noticed was the listings of USA Weightlifting certified club gyms (http://www.teamusa.org/usa-weightlifting/clubs-lwc/find-a-club).  The gyms stood out to me because the page is setup in a very unfriendly manner where the user can only look at gyms by selecting the state in which they are located.  There is no search or other easy lookup method, like a map.

Now that I identified what I was going to scrape, I had to figure out what are the important details of a gym.  To determine those details, I just click through to any state and examine what the webpage tells me about each gym.  Hmmm, OK.  It looks like each Gym will have several attributes which include: the gym's name, full address, phone number, director name, and director phone.  It would have been awesome if there was more information, but this will have to do for now.   

I use [Bundler](http://bundler.io/) (a cool program that manages Ruby gems), so creating a gem from scratch is as easy as typing
```bash
bundle gem closest_weightlifting_gem
```
