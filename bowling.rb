require 'rspec'

def calculate_score(game)
  game.chars
      .map(&:to_i)
      .inject(&:+)
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

end