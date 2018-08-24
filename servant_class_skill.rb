# サーヴァントクラススキルクラス
class ServantClassSkill
  attr_accessor :number, :name, :effect

  def initialize(number, name, effect)
    @number = number
    @name = name
    @effect = effect
  end
end
