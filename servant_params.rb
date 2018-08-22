# サーヴァントパラメータクラス
class ServantParams
  attr_accessor :number, :hp, :atk, :cost, :cards, :strength,
    :endurance, :agile, :magical_power, :fortune, :noble_phantasm

  def initialize(number, hp, atk, cost, cards, strength,
      endurance, agile, magical_power, fortune, noble_phantasm)
    @number = number
    @hp = hp
    @atk = atk
    @cost = cost
    @cards = cards
    @strength = strength
    @endurance = endurance
    @agile = agile
    @magical_power = magical_power
    @fortune = fortune
    @noble_phantasm = noble_phantasm
  end
end
