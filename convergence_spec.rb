require 'minitest/autorun'
require 'minitest/spec'

class Vector
  attr_accessor :x, :y

  def initialize(x=0, y=0)
    @x = x
    @y = y
  end
end

class Owner < Vector

end

class Holo < Vector
  def converge(owner)
    self.x += converge_axis(owner.x, x)
    self.y += converge_axis(owner.y, y)
  end

  def converge_axis(owner_pos, pos)
    max_follow_distance = 2
    move = 0
    if owner_pos > pos
      move = owner_pos - pos
    elsif owner_pos < pos
      move = -(pos - owner_pos)
    end
    if move.abs > max_follow_distance
      if move > 0
        move -= max_follow_distance
      elsif move < 0
        move += max_follow_distance
      end
    else
      move = 0
    end
    move
  end
end

describe "Convergence" do
  describe "distance less or equal than max follow distance" do
    it "does not converges a positive holo on a greater positive owner" do
      holo = Holo.new(3)
      holo.converge(Owner.new(5))
      holo.x.must_equal 3
      holo.converge(Owner.new(4))
      holo.x.must_equal 3
      holo.converge(Owner.new(3))
      holo.x.must_equal 3
    end
  end

  describe "distance greater than max follow distance" do
    it "converges holo on a greater owner" do
      holo = Holo.new(2)
      holo.converge(Owner.new(5))
      holo.x.must_equal 3
      holo = Holo.new(-1)
      holo.converge(Owner.new(5))
      holo.x.must_equal 3
      holo = Holo.new(-5)
      holo.converge(Owner.new(-2))
      holo.x.must_equal -4
    end

    it "converges a positive holo on a lesser positive owner" do
      holo = Holo.new(5)
      holo.converge(Owner.new(2))
      holo.x.must_equal 4
      holo = Holo.new(5)
      holo.converge(Owner.new(-1))
      holo.x.must_equal 1
      holo = Holo.new(5)
      holo.converge(Owner.new(-3))
      holo.x.must_equal -1
      holo = Holo.new(-1)
      holo.converge(Owner.new(-5))
      holo.x.must_equal -3
    end
  end

  describe "y axis" do
    it "converges holo on a greater owner" do
      holo = Holo.new(0,2)
      holo.converge(Owner.new(0,5))
      holo.y.must_equal 3
    end
  end
end