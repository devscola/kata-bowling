require 'rspec'

class Game
  def self.score_for(gamecard)
    self.new(gamecard).score
  end

  def initialize(gamecard)
    @frames = extract_frames_from(gamecard)
    @pending_bonus_count = 0
    #elim
    @frames_with_pending_score = 0
  end

  def score
    @frames.inject(0) do |accumulator, frame|
      number_of_bonuses = bonuses_to_use(frame)

      #unir
      accumulator += frame.score
      accumulator += frame.bonificable_score(number_of_bonuses)

      #segregar resp. mantenimiento de bonus fuera de score
      update_bonus_count(number_of_bonuses, frame)

      accumulator
    end
  end

  private

  def bonuses_to_use(frame)
    [@frames_with_pending_score * frame.number_of_rolls, @pending_bonus_count].min
  end

  # refactor
  def update_bonus_count(amount, frame)
    @pending_bonus_count -= amount
    if @pending_bonus_count < 0
      @pending_bonus_count = 0
    end
    if frame.strike?
      @pending_bonus_count += 2
      @frames_with_pending_score += 1
    elsif frame.spare?
      @pending_bonus_count += 1
      @frames_with_pending_score += 1
    end
  end

  def extract_frames_from(gamecard)
    # eliminar ñapa
    regular_frames = gamecard.gsub("X", "X-")
                      .chars[0..18]
                      .each_slice(2)
                      .map {|rolls| Frame.new(rolls.join) }

    last_frame = Frame.new(gamecard.gsub("X", "X-")
                      .chars[18..-1]
                      .join)

    regular_frames << last_frame
  end
end

# check methods visibility
class Frame
  SPARE = '/'
  STRIKE = 'X'

  MAX_POINTS = 10

  def initialize(roll_list)
    @rolls = roll_list.gsub('X-', 'X').chars
  end

  def score
    return MAX_POINTS if all_pins_down?

    @rolls.map(&:to_i).inject(&:+)
  end

  def first_roll_score
    return MAX_POINTS if strike?
    @rolls[0].to_i
  end

  def second_roll_score
    return MAX_POINTS - first_roll_score if spare?
    return nil if strike?
    @rolls[1].to_i
  end

  def bonificable_score(bonus_count)
    roll_scores = [first_roll_score, second_roll_score].compact
    result = 0
    bonus_count.times do |i|
      result += roll_scores[i % number_of_rolls].to_i
    end
    result
  end

  def all_pins_down?
    spare? || strike?
  end

  def number_of_rolls
    @rolls.size
  end

  def spare?
    @rolls.include?(SPARE)
  end

  def strike?
    @rolls.include?(STRIKE)
  end
end

#####################
def calculate_score(gamecard)
  Game.score_for(gamecard)
end

#####################
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

  it "spare in the first frame and 5 pins down in the first roll of the second frame score 20" do

    game = "5/5-----------------"

    score = calculate_score(game)

    expect(score).to eq(20)
  end

  it "strike in the first frame and 5 pins down scores 20" do

    game = "X5-----------------"

    score = calculate_score(game)

    expect(score).to eq(20)
  end

  it "strike in the two first frames and 3+4 pins down scores 47" do

    game = "XX34--------------"

    score = calculate_score(game)

    expect(score).to eq(47) #27 + (13 + 7)
  end

  it "all spares and 5 pins down in extra roll score 150" do

    game = "5/5/5/5/5/5/5/5/5/5/5"

    score = calculate_score(game)

    expect(score).to eq(150)
  end

  it "perfect game score 300" do

    game = "XXXXXXXXXXXX"

    score = calculate_score(game)

    expect(score).to eq(300)
  end
end
