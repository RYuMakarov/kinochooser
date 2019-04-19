# encoding: utf-8

if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end

require 'mechanize'
require 'active_support/all'

agent = Mechanize.new()

chesen = false

until chesen
  page = agent.get("https://www.kinopoisk.ru/top/lists/1/filtr/all/sort/order/perpage/100/page/#{rand(5)}/")

  tr_tag = page.search("//tr[starts-with(@id, 'tr_')]").to_a.sample

  kino_title = tr_tag.search("a[@class='all']").text
  kinopoisk_rating = tr_tag.search("span[@class='all']").text
  kinopoisk_link = "http://kinopoisk.ru/film/#{tr_tag.attributes["id"]}/"
  film_description = tr_tag.search("span[@class='gray_text']")[0].text

  puts kino_title
  puts film_description
  puts "Рейтинг Кинопоиска: #{kinopoisk_rating}"

  puts "Смотрим? (Y/N)"

  choise = STDIN.gets.chomp

  if choise.downcase == 'y'
    puts "Полное описание фильма: #{kinopoisk_link.remove(/tr_/)}"
    chesen = true
  end
end