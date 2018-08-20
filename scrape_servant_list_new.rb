
# http://d.hatena.ne.jp/otn/20090509/p1

# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
# Nokogiriライブラリの読み込み
require 'nokogiri'
require 'mechanize'

# スクレイピング先のURL
url = 'https://grand_order.wicurio.com/index.php?%E3%82%B5%E3%83%BC%E3%83%B4%E3%82%A1%E3%83%B3%E3%83%88%E4%B8%80%E8%A6%A7'

charset = nil
html = open(url) do |f|
  charset = f.charset # 文字種別を取得c
  f.read # htmlを読み込んで変数htmlに渡す
end

# htmlをパース(解析)してオブジェクトを生成
doc = Nokogiri::HTML.parse(html, nil, charset)

# タイトルを表示
p doc.title

table = doc.css(".style_table > tbody > tr")

# サーヴァントの詳細URLを取得し、リスト化する
url_list = Array.new
table.each{|col|
  no = col.css("th")[0]
  name = col.css("td")[2]
  if (!name.nil?) then
    servant = name.css('a')
    if (servant.inner_text == "") then
      next
    end
    # p servant.inner_text
    # p servant[0][:href]
    url_list.push(servant[0][:href])
  end
}

# 各サーヴァントのページを取得する
p url_list.length
url_list.each{|url|
  # agent = Mechanize.new
  # page = agent.get(url)
  # p page.search('title')
}

# サーヴァントの詳細情報を取得する
url = url_list[220]
charset = nil
html = open(url) do |f|
  charset = f.charset
  f.read
end

doc = Nokogiri::HTML.parse(html, nil, charset)

# タイトル
p "-----title-------"
p doc.title

body = doc.css("#body > div > table")[0]

tr = body.css('tr')

# レア度、No
rare = tr[0].css('th')[0].inner_text
p rare
no = tr[0].css('th')[1].inner_text
p no

# クラス、属性
clazz = tr[1].css('td')[1].inner_text
p clazz
attri = tr[1].css('td')[2].inner_text
p attri

# 真名
name = tr[2].css('td')[0].inner_text
p name

# 時代
age = tr[3].css('td')[0].inner_text
p age

# 地域
region = tr[4].css('td')[0].inner_text
p region

# HP/ATK
tr[6..7].each{|score|
  key = score.css('th').inner_text
  value = score.css('td').inner_text
  p key + ' : ' + value
}

# 能力値
tr[8..10].each{|status|
  key = status.css('th')[0].inner_text
  value = status.css('td')[0].inner_text
  p key + ' : ' + value
  key = status.css('th')[1].inner_text
  value = status.css('td')[1].inner_text
  p key + ' : ' + value
}

# コスト
cost = tr[11].css('td')[0].inner_text
p cost

# 保有カード
tr[12].css('td').each{|card|
  p card.inner_text
}

# スキル
skill_list = Array.new
class_skill_index = 0
flg = false
tr.each_with_index{|ele, i|
  if (flg) then
    skill_list.push(ele)
  end
  if (ele.css('th').first == nil) then
    next
  end
  word = ele.css('th').first.inner_text
  if (flg == false && word == '保有スキル') then
    flg = true
  end
  if (flg == true && word == 'クラススキル') then
    skill_list.pop()
    class_skill_index = i + 1
    break
  end
}

skill_list.each{|ele|
  p "---------------------"
  values = ele.css("td")

  values.each{|value|
    if (!value.inner_text.empty?) then
      p value.inner_text
    end
  }
}

# クラススキル
nobel_index = 0
tr[class_skill_index..tr.length].each_with_index{|ele, i|
  word = ''
  if (!ele.css('th').empty?) then
    word = ele.css('th')[0].inner_text
  end
  if (word == '宝具名') then
    nobel_index = i + 1
    break
  end
  if (ele.css('td').length == 1) then
    p ' : ' + ele.css('td')[0].inner_text
    next
  end
  p ele.css('td')[0].inner_text + ' : ' + ele.css('td')[1].inner_text
}

# 宝具
p tr[nobel_index]