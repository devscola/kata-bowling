require 'rspec'
class Game
  def self.score_for(gamecard)
    self.new(gamecard).score
  end

  def initialize(gamecard)
    @frames = gamecard
  end

  def score
    first_frame = Frame.new(@frames)
    first_frame.score
  end
end

class Frame
  def initialize(try_list)
    @tries = try_list.chars
  end

  def score
    return 10 if @tries.include?('/')
    @tries.map(&:to_i).inject(&:+)
  end
end

def calculate_score(gamecard)
  Game.score_for(gamecard)
end

describe 'Bowling' do
  it "all misses score 0" do
    # arrange
    game = "--------------------"

    # act
    score = calculate_score(game)

    # assert
    expect(score).to eq(0)
  end

  it "seven pins down on the first try scores 7" do
    # arrange
    game = "7-------------------"

    # act
    score = calculate_score(game)

    # assert
    expect(score).to eq(7)
  end

  it "nine pins down on the first frame score 9" do
    game = "72------------------"

    score = calculate_score(game)

    expect(score).to eq(9)
  end

  it "spare in the first frame score 10" do

    game = "7/------------------"

    score = calculate_score(game)

    expect(score).to eq(10)
  end
end