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

etr = tr[0]
txt = etr.css("th")
tr.each{|ele|
  p "---------------------"
  key = ele.css("th").inner_text
  value = ele.css("td").inner_text

  keys = ele.css("th")
  values = ele.css("td")

  keys.each{|key|
    p "key =  " + key
  }

  values.each{|value|
    p "value = " + value
  }
}