require 'rspec'

def calculate_score(game)
  game.to_i
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

end