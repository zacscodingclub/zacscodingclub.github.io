# Ember Testing

1. Unit Tests
  * Exercise a small part of application while trying to isolate from dependencies
  * Think functions or methods on an object with clear set of inputs & outputs
  * assert that the output will have some specific value

```javascript
import { formatDuration } from 'bumbox/helpers/format-duration';

module("formatting durations"); // Names the testing module

test("it formats durations correctly", function() {
  equal(formatDuration(0), '0:00', "0 is converted to 0:00");
  equal(formatDuration(8), '0:08', "Less than 10 seconds gets 0-padded");
  equal(formatDuration(20), '0:20', "Numbers with trailing zeros are not truncated");
  equal(formatDuration(60), '1:00', "Exactly 60 seconds is converted to 1:00");
  equal(formatDuration(61), '1:01', "Less than 10 seconds into a minute gets 0-padded");
  equal(formatDuration(70), '1:10', "Numbers with trailing zeros greater than one minute are not truncated");
  equal(formatDuration(125), '2:05', "The helper works with multiple minutes");
});
```

2. Integration Tests
  * Simulate user interaction in many parts of app together

```javascript
import Ember from 'ember';
import { test } from 'ember-qunit';
import startApp from '../helpers/start-app';

var App;

module('Creating a post', {
  setup() {
    App = startApp();
  },
  teardown() {
    Ember.run(App, App.destroy);
  }
});

test("When a user creates a post they see it on the index page", function() {
  visit('/');

  click('a:contains(Add a task)');
  fillIn('input[type=text]', 'New Task Title');
  fillIn('textarea', 'New task description');
  click('button:contains(Save)');

  // andThen waits for all previous events to complete before running
  andThen(function() {
    equal(currentURL(), '/');
    equal(find('label:contains(New Task Title)').length, 1);
    equal(find('p:contains(New task description)').length, 1);
  });
});
```

3. End to End Tests (Acceptance or feature)
  * Realistic view of your application in a browser.
