# サーヴァント宝具クラス
class NoblePhantasm
  attr_accessor :servant_no, :name, :rank, :card_type, :type, :effect

  def initialize(servant_no, name, rank, card_type, type, effect)
    @servant_no = servant_no
    @name = name
    @rank = rank
    @card_type = card_type
    @type = type
    @effect = effect
  end
end