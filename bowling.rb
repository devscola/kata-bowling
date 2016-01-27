require 'rspec'

def calculate_score(game)
  0
end

describe 'Bowling' do
  it "all misses score 0" do
    # arrange
    game = "--------------------"

    # act
    score = calculate_score(game)

    # evaluate
    expect(score).to eq(0)
  end
end