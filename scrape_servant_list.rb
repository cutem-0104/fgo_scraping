# http://d.hatena.ne.jp/otn/20090509/p1

# URLにアクセスするためのライブラリの読み込み
require 'open-uri'
require 'fileutils'
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
    p servant.inner_text
    p servant[0][:href]
    url_list.push(servant[0][:href])
  end
}

# 各サーヴァントのページを取得する
url_list.each{|url|
  # agent = Mechanize.new
  # page = agent.get(url)
  # p page.search('title')
}

# サーヴァントの詳細情報を取得する
url = url_list[10]
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

key_list = Array.new
value_list = Array.new
tr.each{|ele|
  p "---------------------"
  keys = ele.css("th")
  values = ele.css("td")

  keys.each{|key|
    if (!key.inner_text.empty?) then
      p "key =  " + key
      key_list.push(key.inner_text)
    end
  }

  values.each{|value|
    if (!value.inner_text.empty?) then
      p value.inner_text
      value_list.push(value.inner_text)
    end
  }
}

# レア度　No
p key_list[0]
p key_list[1]

image = body.css('tr')[1].css('td > img').first.attribute('src').value
p image
# ready filepath
dirName = "data/"
filePath = dirName + key_list[1]
p filePath

# create folder if not exist
FileUtils.mkdir_p(dirName) unless FileTest.exist?(dirName)

# write image adata
open(filePath, 'wb') do |output|
  open(url) do |data|
    output.write(data.read)
  end
end
# パラメーター 宝具まで
key_list[2..12].zip(value_list) do |k, v|
  p k + ' : ' + v
end

# パラメーター COSTまで
key_list[14..16].zip(value_list[11..13]) do |k, v|
  p k + ' : ' + v
end

# 保有カード
key = key_list[17]
cards = Array.new
value_list[14..16].each{|card|
  cards.push(card)
  p key + ' : ' + card
}

# 保有スキル1
key_list[18..22].zip(value_list[17..21]) do |k, v|
  p k + ' : ' + v
end

# 保有スキル2
key_list[18..22].zip(value_list[24..28]) do |k, v|
  p k + ' : ' + v
end

# 保有スキル3
key_list[18..22].zip(value_list[31..35]) do |k, v|
  p k + ' : ' + v
end

# クラススキル
key_list[23..24].zip(value_list[39..40]) do |k, v|
  p k + ' : ' + v
end

# クラススキル
key_list[23..24].zip(value_list[41..42]) do |k, v|
  p k + ' : ' + v
end

# 宝具
key_list[25..29].zip(value_list[43..47]) do |k, v|
  p k + ' : ' + v
end

