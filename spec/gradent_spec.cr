require "./spec_helper"

TestValues = [
  {
    min: 0_u8,
    max: 255_u8,
    low: 0,
    quarter: 0x40,
    mid: 0x7F,
    threequarter: 0xBF,
    full: 0xFF
  },
  {
    min: 0x7F_u8,
    max: 255_u8,
    low: 0x7F,
    quarter: 0xA0,
    mid: 0xBF,
    threequarter: 0xDF,
    full: 0xFF
  },
  {
    min: 0_u8,
    max: 0x7F_u8,
    low: 0,
    quarter: 0x20,
    mid: 0x40,
    threequarter: 0x5F,
    full: 0x7F
  }
]

module Colors

  describe Gradient do
    TestValues.each do |color|
      grad = Gradient.new :red, :green, from: color[:min], upto: color[:max]
      it "Gets the right value at 1:2 with min  #{ color[:min] } and max  #{ color[:max] }" do
        grad.low_color.should eq :red
        grad.high_color.should eq :green
        grad[50].red.to_i.should be_close expected: color[:mid], delta: 2
        grad[50].blue.should eq 0
        grad[50].green.to_i.should be_close expected: color[:mid], delta: 2
      end
      it "Gets the right value at 1:4 with min  #{ color[:min] } and max  #{ color[:max] }" do
        grad.low_color.should eq :red
        grad.high_color.should eq :green
        grad[25].red.to_i.should be_close expected: color[:threequarter], delta: 2
        grad[25].blue.should eq 0
        grad[25].green.to_i.should be_close expected: color[:quarter], delta: 2
      end
      it "Gets the right value at 1:1 with min  #{ color[:min] } and max  #{ color[:max] }" do
        grad.low_color.should eq :red
        grad.high_color.should eq :green
        grad[100].red.should eq color[:low]
        grad[100].green.should eq color[:full]
        grad[100].blue.should eq color[:low]
      end
      it "Gets the right value at 0:1 with min  #{ color[:min] } and max  #{ color[:max] }" do
        grad.low_color.should eq :red
        grad.high_color.should eq :green
        grad[0].red.should eq color[:full]
        grad[0].green.should eq color[:low]
        grad[0].blue.should eq color[:low]
      end
      it "Gets the right value at 3:4 with min  #{ color[:min] } and max  #{ color[:max] }" do
        grad.low_color.should eq :red
        grad.high_color.should eq :green
        grad[75].red.to_i.should be_close color[:quarter], delta: 2
        grad[75].green.to_i.should be_close color[:threequarter], delta: 2 # (0xFF * 4 / 3)
        grad[75].blue.should eq color[:low]
      end
    end
    grad = Gradient.new
    it "iterates over the whole gradient" do
      counter = 0
      grad.each { counter+=1 }
      counter.should eq grad.max
    end
    it "iterates with an index" do
      counter = 0
      grad.each_with_index do |c, i|
        grad[i].red.should eq c.red
        grad[i].green.should eq c.green
        counter += 1
      end
      counter.should eq grad.max
    end
  end
end
