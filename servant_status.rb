# サーヴァントステータスクラス
class ServantStatus
  attr_accessor :rare, :clazz, :attri, :number, :name, :age, :region

  def initialize(rare, clazz, attri, number, name, age, region)
    @rare = rare
    @clazz = clazz
    @attri = attri
    @number = number
    @name = name
    @age = age
    @region = region
  end
end
