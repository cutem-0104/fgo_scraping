# サーヴァントスキルクラス
class ServantSkill
  attr_accessor :number, :name, :effect, :continuation, :ct, :condition

  def initialize(number, name, effect, continuation, ct, condition)
    @number = number
    @name = name
    @effect = effect
    @continuation = continuation
    @ct = ct
    @condition = condition
  end
end
