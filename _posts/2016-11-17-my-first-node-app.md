---
layout: post
title: "Using NodeJS to Parse Daily Fantasy Sports (DFS) Lineups"
---

Earlier this week a friend was talking about wanting to learn how to program and a project he wanted to complete. The basics of this idea are to get DFS lineups for contests, parse the data, calculate some frequency statistics and output that new information. Since I'm fairly new to developing applications and excited to learn more, I thought it would be fun to attempt this using NodeJS (a language I've never really used). Wile I've played and watched a lot of sports over my lifetime I've never played DFS, so please excuse my ignorance if I say something that is completely wrong.

To get started, I setup a new folder called `linup_frequency`, then moved into the directory and used `npm init` to create a `package.json` file with some basic metadata about the app.  When you do this, it asks what the entry point of your app is going to be and I just went with the default, `index.js`.  Next I type in `git init` to initialize my directory as a Git repository so I can track changes I make to the code.  

Next I need to understand a little bit about what kind of data I'm going to be dealing with.  When a DFS contest is completed, a user can download a CSV file detailing various basic information about every lineup that was entered into the contest.  The CSV contains a header on the first line that looks similar to this:
```
Rank,EntryId,EntryName,TimeRemaining,Points,Lineup,,Player,%Drafted,FPTS
```
The key columns I'll need to focus on are `Lineup` and `Player`.  I went ahead and studied the data a little bit looking through to see how these fields are structured so I could consider how to parse them later.  

Knowing that I need to parse a CSV file using Node, I did what any sensible person would do and googled "node csv".  After looking through a couple libraries, I decided on [fast-csv](https://www.npmjs.com/package/fast-csv).  This library has tons of downloads and solid documentation which was more than enough to get me off and running.  To download and install it, I just had to add a small bit of code to the `package.json` (as seen below), then run `npm install` from the command line.

```
{
  ...
  "dependencies": {
		"fast-csv": "~2.3.0"
	},
  ...
}
```

This command creates a new folder called `node_modules` and it's the directory where Node libraries get installed locally, as in local to this project.  These modules can also be installed globally, but let's not look into that just quite yet.  To make sure this installed correctly, we need to open up the `index.js` file and require the library like this:

```
var csv = require('fast-csv');
console.log("Hello World");
```
Then run the application by typing `node index` into the command line.  If it
