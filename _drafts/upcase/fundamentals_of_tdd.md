# Fundamentals of TDD

* Suite of regression tests (easier changes)
* Positive design pressure
* Workflow benefit of tacking problem in small steps
* Tests are automated, living documentation

## Red-Green-Refactor
* (Red)      - Start with writing a test
* (Green)    - Make the test pass
* (Refactor) - Clean up code logic and tests so they are easier to understand

```ruby
require 'rspec/autorun'

describe Calculator do
  describe "#add" do
    it "adds two numbers" do
      calc = Calculator.new
      expect(calc.add(5, 10)).to eq(15)
    end
  end
end
```

## Telling a Story with Your Tests

### Four Phases of Testing
1. Setup
2. Exercise - execute under test
3. Verification
4. Teardown - undo any side effects to other tests

```ruby
describe "#promote_to_admin" do
  it "makes a regular membership an admin membership" do
    # setup
    membership = Membership.new(admin: false)

    # exercise
    membership.promote_to_admin

    # verify
    expect(membership).to be_admin

    # object only exists in scope of test, so teardown is automatic
  end
end
```

### before, after, and let Blocks
* `before` runs before each test (setup)
* `after` runs after each test (teardown)
* `let` acts similar to a regular function to set needed variables

* `before` and `let` can be anti-patterns due to making tests less readable.  DRY is applicable to application code, but applying it to testing removes the "tests as documentation" benefit of writing tests

## Unit Converter

```ruby
describe UnitConverter do
  describe "#convert" do
    it "translates between objects of the same dimension" do
      converter = UnitConverter.new(2, :cup, :liter)

      expect(converter.convert).to be_within(0.001).of(0.473176)
    end

    it "raises an error if the objects are of differing dimensions" do
      converter = UnitConverter.new(2, :cup, :grams)

      # when testing the error, you actually pass in a block instead of simply
      # executing the method like before.
      expect { converter.convert }.to raise_error(DimensionalMismatchError)
    end
  end
end
```

* change `it` to `xit` to make test pending instead of running every time, helps isolate specific tests


## Refactoring with Test Coverage


## Integration vs Unit Tests

* Unit tests test a single part of your application, typically a class or more simply put, a method on a class

### In Rails
* Integration - Feature tests - high level step through your application.  Visit site, click button, do something etc.
* Unit - Controller & Model - more of an unit test

### Integration Test
* Benefits
  1. Confirms features of an application are working correctly
  2. Units can all be passing, but the interface does not behave correctly
  3. Starting with feature tests can allow you to drive which unit tests are needed
  4. Really helps when you have collaborating objects

## Going Further with TDD
### Books
* The RSpec Book
* Rails 4 Test Prescriptions
* Testing Rails

### Series
* Test Doubles
* Test Driven Rails
* Weekly Iteration
 * https://thoughtbot.com/upcase/videos/four-phases-of-testing
 * https://thoughtbot.com/upcase/videos/demonstrate-class-design-via-tdd
 * https://thoughtbot.com/upcase/videos/speedy-tests
 * https://thoughtbot.com/upcase/videos/integration-vs-unit-testing
 * https://thoughtbot.com/upcase/videos/integration-vs-unit-testing
