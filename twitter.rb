# encoding: UTF-8
#Задача 14-1: Улучшите наш твиттер-клиент, добавив в него возможность загрузки картинок.
# подключаем библиотеку
#require 'rubygems'
require 'Twitter'
require 'optparse'
#require 'byebug'


# Все наши опции будут записаны сюда (см. код урока 12)
options = {}

# заведем нужные нам опции
OptionParser.new do |opt|
  opt.banner = 'Usage: twitter.rb [options]'

  opt.on('-h', 'Вывод помощи по настройкам') do
    puts opt
    exit
  end

  opt.on('--tweet "tweet"', 'Затвитить "твит"') { |o| options[:tweet] = o } # создаст новый твит и запустит
  # сообщение
  opt.on('--timeline USER_NAME', 'Показать последние твиты') { |o| options[:timeline] = o } # выведет 
  # последние несколько твитов данного USER_NAME
  opt.on('--image "PATH_TO_IMAGE"', 'Загрузить картинку') { |o| options[:image] = o } # загрузит в твиттер картинку

end.parse!


# конфигурируем твитер клиент согласно документации https://github.com/sferik/twitter/blob/master/examples/Configuration.md
client = Twitter::REST::Client.new do |config| # в переменной client будет экземпляр нашего твиттера
  # ВНИМАНИЕ! Эти параметры уникальны для каждого приложения, вы должны
  # зарегистрировать в своем аккаунте новое приложение на https://apps.twitter.com
  # и взять со страницы этого приложения данные настройки!
    config.consumer_key = 'pgSysMSgrEfpwYx2rvtfdrKVM'
    config.consumer_secret = 'sG5WW0wHyfJMqXXGDVnpdXgrUZ8lUIyDzlOxQNKJMrs6uJj9VN'
    config.access_token = '738771354380578816-OFTniiBJbVS6W208UdopOI4R9MgkAUG'
    config.access_token_secret = '8tQknHf7LvHr5cLXWmTreR2ia2aUudKuif12zFvXtNCzc'
end



# Постим новый твит https://github.com/sferik/twitter/blob/master/examples/Update.md
if options.key?(:tweet)
  puts "Постим твит: #{options[:tweet].encode("UTF-8")}"
  client.update(options[:tweet].encode("UTF-8"))
  puts "Твит запощен."
end

#Twitter.update("I'm tweeting with @gem!")

#загрузим картинку с адреса, например, e:/Мои документы/Фото/Я и Оля/DSC_0000009.jpg.
if options.key?(:image)
  puts "Загружаем картинку #{options[:image].encode("UTF-8")} в твиттер"
  image_path = options[:image].encode("UTF-8") # загружаем в переменную  image_path путь к файлу с картинкой
  if File.exist?(image_path) # проверяем существование файла с картинкой
  client.update_with_media("", File.new("#{image_path}")) 
  puts "Картинка загружена"
  else 
      puts "Файл с картинкой не найден"  # если картинка не найдена 
  end 
end


# запрос на вывод последних твитов из ленты
if options.key?(:timeline)
  puts "Лента юзера: #{options[:timeline]}"
  # Опции вывода ленты твитов, подробнее: https://github.com/sferik/twitter/blob/master/examples/AllTweets.md
  opts = {count: 7, include_rts: true} # число последних твитов - 7, включаем ретвиты в ленту
  tweets = client.user_timeline(options[:timeline], opts) # хеш массив опций opts из гема twitter

  # выводим массив полученных твитов TODO: refactor method code duplicate - show rubymine feature!
  tweets.each do |tweet|
    puts tweet.text # метод text
    puts "by @#{tweet.user.screen_name}, #{tweet.created_at}" # выодим имя пользователя и когда написан 
    puts "-"*40 # делаем 40 дефисов подряд, чтобы разделить сообщение 
  end
else
  puts "Моя лента:" # если :timeline не передана, то выводим собственную ленту

  # запрашиваем френдленту пользователя, с чьими ключами авторизовывались на строчках 31-34 этой программы
  tweets = client.home_timeline({count: 5})# последние 5 выведем

  # выводим массив полученных твитов TODO: refactor method code duplicate - show rubymine feature!
  tweets.each do |tweet|
  #  byebug
    puts tweet.text
    puts "by @#{tweet.user.screen_name}, #{tweet.created_at}"
    puts "-"*40
  end
end
