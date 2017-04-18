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
