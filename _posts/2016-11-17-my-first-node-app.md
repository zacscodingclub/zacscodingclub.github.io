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

```javascript
{
  ...
  "dependencies": {
		"fast-csv": "~2.3.0"
	},
  ...
}
```

This command creates a new folder called `node_modules` and it's the directory where Node libraries get installed locally, as in local to this project.  These modules can also be installed globally, but let's not look into that just quite yet.  To make sure this installed correctly, we need to open up the `index.js` file and require the library like this:

```javascript
var csv = require('fast-csv');
console.log("Hello World");
```
Then run the application by typing `node index` into the command line.  If it there are no errors and you see "Hello World" in the console, things are working smoothly.

The CSV files that were provided for each contest were pretty large at over 100MB of text and commas, so I decided to copy one and truncate down to 10 rows of data while testing the program, which looks like this:
```
Rank,EntryId,EntryName,TimeRemaining,Points,Lineup,,Player,%Drafted,FPTS
1,557031802,ryanschumm,0,59,C Nazem Kadri C Radek Faksa W Wayne Simmonds W Jordan Eberle W Mitchell Marner D Radko Gudas D Morgan Rielly G Keith Kinkaid UTIL Mark Scheifele,,Connor McDavid,27.15%,4
2,557767406,suntzjim (19/22),0,58.4,C Mikhail Grigorenko C Connor McDavid W Blake Wheeler W Wayne Simmonds W Patrick Maroon D Radko Gudas D Morgan Rielly G Craig Anderson UTIL Nikolaj Ehlers,,Oscar Klefbom,19.68%,0.5
3,557767409,suntzjim (22/22),0,56.9,C Sam Reinhart C Auston Matthews W Blake Wheeler W Wayne Simmonds W Patrick Maroon D Radko Gudas D Morgan Rielly G Braden Holtby UTIL Nikolaj Ehlers,,Patrick Maroon,19.38%,5.5
4,557349188,Emanmae,0,56.7,C Jeff Carter C Travis Zajac W Wayne Simmonds W Jordan Eberle W Marcus Johansson D Radko Gudas D Morgan Rielly G Anders Nilsson UTIL Blake Wheeler,,Jordan Eberle,18.58%,4
5,556972360,Nufan55 (2/3),0,56.5,C Tyler Bozak C Tyler Seguin W Patrick Eaves W Jamie Benn W Mitchell Marner D Radko Gudas D Morgan Rielly G Keith Kinkaid UTIL James van Riemsdyk,,Keith Kinkaid,17.60%,7
6,556996839,awalker97 (79/150),0,56.4,C Claude Giroux C Jean-Gabriel Pageau W Wayne Simmonds W Zack Smith W Brayden Schenn D Erik Karlsson D Morgan Rielly G Craig Anderson UTIL Ryan Dzingel,,Claude Giroux,17.41%,3.5
7,556961451,theedeazz (5/8),0,56.2,C Claude Giroux C Tyler Seguin W Wayne Simmonds W Tyler Pitlick W Antoine Roussel D Morgan Rielly D Shayne Gostisbehere G Anders Nilsson UTIL Patrick Eaves,,Patrik Laine,15.87%,1
8,556796292,Thorty (108/150),0,55.5,C Nazem Kadri C Tyler Seguin W Patrick Eaves W Antoine Roussel W Leo Komarov D Erik Karlsson D Morgan Rielly G Frederik Andersen UTIL Connor Brown,,Nikolaj Ehlers,15.83%,4.5
9,556796271,Thorty (87/150),0,55,C Tyler Bozak C Tyler Seguin W James van Riemsdyk W Antoine Roussel W Mitchell Marner D Erik Karlsson D Morgan Rielly G Frederik Andersen UTIL Patrick Eaves,,Jakub Voracek,15.51%,0
9,556963453,fewfew (93/150),0,55,C Tyler Bozak C Tyler Seguin W James van Riemsdyk W Antoine Roussel W Mitchell Marner D Erik Karlsson D Morgan Rielly G Frederik Andersen UTIL Patrick Eaves,,James van Riemsdyk,15.33%,3
11,557767395,suntzjim (8/22),0,54.9,C Matt Duchene C Nazem Kadri W Blake Wheeler W Wayne Simmonds W Patrick Maroon D Oscar Klefbom D Morgan Rielly G Craig Anderson UTIL Nikolaj Ehlers,,Anders Nilsson,15.17%,6.2
```

Now With the library loading properly and some test data, it's time to how to use fast-csv to actually parse the file.  fast-csv has (solid documentation)[https://www.npmjs.com/package/fast-csv] which shows a variety of ways to read through files.  After looking through all the options, I decided to use the `.fromStream` option which accepts a read stream created by (Node's File System (fs) library)[https://nodejs.org/api/fs.html] and an options object which allows us to customize how the CSV is read.  For example, we're passing in the `{ headers: true }` parameter to indicate the first line of the file includes the column names.  Then in the example code there there are several event listeners which are the bits of code that start with `.on(event)`.  The first event we see is "data" which turns out being each row in context of a CSV file.  Inside that event listener, I'm simply logging the row as it appears so I can see what it looks like at that moment in the program.  So this will log each row to the console, then once complete it will hit the next event listener "end", which then logs the string "done" to indicate the program is done parsing.

```javascript
  var csv = require('fast-csv'),
       fs = require('fs');

  var stream = fs.createReadStream("contest-truncate.csv");

  csv
   .fromStream(stream, {headers : true})
   .on("data", function(row){
       console.log(row);
   })
   .on("end", function(){
       console.log("done");
  });
 ```

When we run this using `node index`, the console then races on by with lots of text and each row looks like it gets converted to an object like this:
 ```javascript
 { Rank: '1',
   EntryId: '557031802',
   EntryName: 'ryanschumm',
   TimeRemaining: '0',
   Points: '59',
   Lineup: 'C Nazem Kadri C Radek Faksa W Wayne Simmonds W Jordan Eberle W Mitchell Marner D Radko Gudas D Morgan Rielly G Keith Kinkaid UTIL Mark Scheifele',
   '': '',
   Player: 'Connor McDavid',
   '%Drafted': '27.15%',
   FPTS: '4' }
 ```
