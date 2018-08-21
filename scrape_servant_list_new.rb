# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
require 'mechanize'
require './servant_status.rb'

# スクレイピング先のURL
url = 'https://grand_order.wicurio.com/index.php?'
param = '%E3%82%B5%E3%83%BC%E3%83%B4%E3%82%A1%E3%83%B3%E3%83%88%E4%B8%80%E8%A6%A7'

charset = nil
html = OpenURI.open_uri(url + param) do |f|
  charset = f.charset # 文字種別を取得
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

# タイトルを表示
p doc.title

table = doc.css('.style_table > tbody > tr')

# サーヴァントの詳細URLを取得し、リスト化する
url_list = []
table.each do |col|
  # no = col.css('th')[0]
  name = col.css('td')[2]
  next if name.nil?
  servant = name.css('a')
  next if servant.inner_text == ''
  # p servant.inner_text
  # p servant[0][:href]
  url_list.push(servant[0][:href])
end

# 各サーヴァントのページを取得する
p url_list.length
url_list.each do |page|
  # agent = Mechanize.new
  # page = agent.get(url)
  # p page.search('title')
end

# サーヴァントの詳細情報を取得する
url = url_list[0]
charset = nil
html = OpenURI.open_uri(url) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

# タイトル
p '-----title-------'
p doc.title

body = doc.css('#body > div > table')[0]

tr = body.css('tr')

# レア度、No
rare = tr[0].css('th')[0].inner_text
no = tr[0].css('th')[1].inner_text
# クラス、属性
clazz = tr[1].css('td')[1].inner_text
attri = tr[1].css('td')[2].inner_text
# 真名
name = tr[2].css('td')[0].inner_text
# 時代
age = tr[3].css('td')[0].inner_text
# 地域
region = tr[4].css('td')[0].inner_text

s_status = ServantStatus.new(rare, clazz, attri, no, name, age, region)
p s_status.rare
p s_status.clazz
p s_status.attri
p s_status.number
p s_status.name
p s_status.age
p s_status.region

# 能力値が入れ替わっている場合を考慮
if tr[5].css('th').inner_text.include?('能力値')
  # HP/ATK
  tr[6..7].each do |score|
    key = score.css('th').inner_text
    value = score.css('td').inner_text
    p key + ' : ' + value
  end

  # 能力値
  tr[8..10].each do |status|
    key = status.css('th')[0].inner_text
    value = status.css('td')[0].inner_text
    p key + ' : ' + value
    key = status.css('th')[1].inner_text
    value = status.css('td')[1].inner_text
    p key + ' : ' + value
  end
else
  # HP/ATK
  tr[9..10].each do |score|
    key = score.css('th').inner_text
    value = score.css('td').inner_text
    p key + ' : ' + value
  end

  # 能力値
  tr[5..7].each do |status|
    key = status.css('th')[0].inner_text
    value = status.css('td')[0].inner_text
    p key + ' : ' + value
    key = status.css('th')[1].inner_text
    value = status.css('td')[1].inner_text
    p key + ' : ' + value
  end
end
# コスト
cost = tr[11].css('td')[0].inner_text
p cost

# 保有カード
tr[12].css('td').each do |card|
  p card.inner_text
end

# スキル
skill_list = []
class_skill_index = 0
flg = false
tr.each_with_index do |ele, i|
  skill_list.push(ele) if flg
  next if ele.css('th').first.nil?
  word = ele.css('th').first.inner_text
  flg = true if flg == false && word == '保有スキル'
  next if flg == false || word != 'クラススキル'
  skill_list.pop
  class_skill_index = i + 1
  break
end

skill_list.each do |ele|
  p '---------------------'
  values = ele.css('td')

  values.each do |value|
    p value.inner_text unless value.inner_text.empty?
  end
end

# クラススキル
nobel_index = 0
tr[class_skill_index..tr.length].each_with_index do |ele, i|
  word = ''
  word = ele.css('th')[0].inner_text unless ele.css('th').empty?
  if word == '宝具名'
    nobel_index = class_skill_index + i + 1
    break
  end
  if ele.css('td').length == 1
    p ' : ' + ele.css('td')[0].inner_text
    next
  end
  p ele.css('td')[0].inner_text + ' : ' + ele.css('td')[1].inner_text
end

# 宝具
tr[nobel_index].css('td').each do |nobel|
  p nobel.inner_text
end
p tr[nobel_index + 2].css('td').inner_text
