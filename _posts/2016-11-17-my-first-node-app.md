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

```javascript
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

Now With the library loading properly and some test data, it's time to how to use fast-csv to actually parse the file.  fast-csv has [solid documentation](https://www.npmjs.com/package/fast-csv) which shows a variety of ways to read through files.  After looking through all the options, I decided to use the `.fromStream` option which accepts a read stream created by [Node's File System library](https://nodejs.org/api/fs.html) referenced by `fs` in the code and an options object which allows us to customize how the CSV is read.  For example, we're passing in the `{ headers: true }` parameter to indicate the first line of the file includes the column names.  Then in the example code there there are several event listeners which are the bits of code that start with `.on(event)`.  The first event we see is "data" which turns out being each row in context of a CSV file.  Inside that event listener, I'm simply logging the row as it appears so I can see what it looks like at that moment in the program.  So this will log each row to the console, then once complete it will hit the next event listener "end", which then logs the string "done" to indicate the program is done parsing.

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

When we run this using `node index`, the console then races by with a wall of text and each row looks like it gets converted to an object like this:

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

This is great information since it shows me how to access each column of the row while inside the callback function for the "data" event listener.  Now I need to figure a couple of things out, 1) how do I extract the individual names from the `Lineup` attribute and 2) how am I going to store that information within the program.  For the first problem, I'm writing a method called `getPlayersFromLineup()` which takes in two arguments from each row, `row.Lineup` and `row.Player`. To extract the values from the lineup, I decided to use a regular expression.  Below is the code I used for this function.  First it saves the regex to a local variable, then it uses the `.split` method on the `lineup` to extract each player name.  Next this leaves an empty string at the beginning of the `splitLineup` array, so we use the `splice` method to remove that and then add the other `player` argument to this `newLineup` array.  Finally we return this `newLineup` array which is just a list of player names.

```javascript
function getPlayersFromLineup(lineup, player) {
    var regex = /C\W|W\W|D\W|G\W|UTIL\W/g;
    var splitLineup = lineup.split(regex);
    var newLineup = splitLineup.slice(1,splitLineup.length);
    newLineup.push(player);
    return newLineup
}
```

For the second problem, my choice for storing all the players is an object since they are very fast and it is relatively easy to store each player as a key-value pair with the player's name being the key and the value being incremented each time they are recognized in a lineup.  To do this, I need to implement two new methods, one called `processLineup()` and another called `addPlayerToPlayers()`.  The `processLineup` function takes in a full lineup of players, which is an array.  The first step in this method modifies each entry in the `lineup` array by trimming off any empty space at the end of each string.  Next it uses a `.forEach` iterator to first check and make sure each item isn't an empty string.  Then it passes the `player` name to the `addPlayerToPlayers` function.  This function simply checks to see if there is already an entry in the `players` object with a key that shares the players name.  If this entry exists, then it simply increments that value by one.  If there is no entry, then it puts the player into the players object and sets it's value to 1.  

```javascript
var players = {};

function processLineup(lineup){
    var processedLineup = lineup.map(Function.prototype.call, String.prototype.trim);

    processedLineup.forEach(function(player){
        if (player) {
            addPlayerToPlayers(player);
        }
    });
}

function addPlayerToPlayers(player) {
    if (players[player]) {
        players[player] ++;
    } else {
        players[player] = 1;
    }
}
```

The main part of the script looks like this:

```javascript
csv
    .fromStream(readStream, { headers: true})
    .on("data", function(row){
        var rowLineup = getPlayersFromLineup(row.Lineup, row.Player);
        processLineup(rowLineup);
    })
    .on("end", function() {
        console.log("Done")
    })
```

And all of the players are stored in the `players` object.  So now we need to figure out how to print out this object in a nice and readable format.  To do this I will implement a method called `printOutput()` which takes in the `players` object.  This function utilizes a variable called `counter` so I can track the rank of each player.  Then it iterates through all of the players and logs their `counter`, name, and value.  

```javascript
function printOutput(players) {
    var counter = 1;
    players.forEach(function(player) {
        console.log(`${counter}. ${player[0]}, ${player[1]}`)
        counter++;
    });
}
```

Great!  We're now printing out some data, but unfortunately it is sorted in a random order.  So at this point I googled how to sort a javascript object by the values and I found [the function below on StackOverflow](http://stackoverflow.com/questions/1069666/sorting-javascript-object-by-property-value).  

```javascript
function sortProperties(obj) {
    var sortable=[];
    for(var key in obj)
        if(obj.hasOwnProperty(key))
            sortable.push([key, obj[key]]);

    sortable.sort(function(a, b) {
      return a[1]-b[1];
    });

    return sortable.reverse();
}
```

Finally our program is able to parse, sort, and print out some useable information!  At this point, the program will only print out the total number of times a player's name occurs in the CSV file, but what we really want is that number divided by the total number of lineups that were entered.  To do this I simply need to create another counter variable before I parse the CSV.  I'll call it `index`, and then for each row that is parsed, I need to increment this variable.  Then in the `printOutput()` function, I need to divide the `player[1]` by this index variable to produce a decimal percentage.  The core of our CSV parser now looks like this:

```javascript
csv
    .fromStream(readStream, { headers: true})
    .on("data", function(row){
        var rowLineup = getPlayersFromLineup(row.Lineup, row.Player);
        processLineup(rowLineup);
        index ++;
    })
    .on("end", function() {
        var sortedPlayers = sortProperties(players);
        printOutput(sortedPlayers);
    })
```

The program is now printing out the ranking and frequency each player occurs in the lineups.  So I have accomplished my goal.  YAY! All this code is posted up on Github: [Lineup frequency](https://github.com/zacscodingclub/lineup-frequency/blob/master/index.js).  In that code I have implemented a few more features to make the program more flexible, so it will look a little bit different but the functionality explained in this post is still the heart of the program.
