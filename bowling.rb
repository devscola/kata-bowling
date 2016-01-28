require 'rspec'

class Game
  def self.score_for(gamecard)
    self.new(gamecard).score
  end

  def initialize(gamecard)
    @frames = extract_frames_from(gamecard)
  end

  def score
    index = 0
    @frames.inject(0) do |accumulator, frame|
      if frame.all_pins_down?
        accumulator += @frames[index + 1].bonificable_score
      end
      index += 1
      accumulator += frame.score
    end
  end

  private

  def extract_frames_from(gamecard)
    gamecard.chars.each_slice(2).map {|frame| Frame.new(frame.join) }
  end
end

class Frame
  SPARE = '/'
  STRIKE = 'X'

  MAX_POINTS = 10

  def initialize(try_list)
    @tries = try_list.chars
  end

  def score
    return MAX_POINTS if all_pins_down?

    @tries.map(&:to_i).inject(&:+)
  end

  def bonificable_score
    @tries.first.to_i
  end

  def all_pins_down?
    spare? || strike?
  end

  private

  def spare?
    @tries.include?(SPARE)
  end

  def strike?
    @tries.include?(STRIKE)
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

  it "strike in the first frame score 10" do

    game = "X------------------"

    score = calculate_score(game)

    expect(score).to eq(10)
  end

  it "spare in first frame and simple 5 pins down in first try of second frame score 20" do

    game = "5/5-----------------"

    score = calculate_score(game)

    expect(score).to eq(20)
  end

  xit "nine pins down on the first frame and four pins down on the second frame score 13" do

    game = "54-4----------------"

    score = calculate_score(game)

    expect(score).to eq(13)
  end

end