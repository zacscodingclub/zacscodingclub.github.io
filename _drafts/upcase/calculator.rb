require 'rspec'

class Calculator
  def add(a, b)
    a + b
  end

  def subtract(a, b)
    a - b
  end

  def multiply(a, b)
    a * b
  end

  def factorial(a)
    (1..a).inject(:*) || 1
  end
end

describe Calculator do
  describe "#add" do
    it "adds two numbers together" do
      calc = Calculator.new

      expect(calc.add(5,10)).to eq(15)
    end
  end

  describe "#subtract" do
    it "subtracts the second argument from the first argument" do
      calc = Calculator.new

      expect(calc.subtract(10,5)).to eq(5)
    end
  end

  describe "#multiply" do
    it "multiplies two arguments together" do
      calc = Calculator.new

      expect(calc.multiply(10,5)).to eq(50)
    end
  end

  describe "#factorial" do
    it "returns 1 when given 0" do
      calc = Calculator.new

      expect(calc.factorial(0)).to eq(1)
    end

    it "returns 120 when given 5" do
      calc = Calculator.new

      expect(calc.factorial(5)).to eq(120)
    end
  end
end
