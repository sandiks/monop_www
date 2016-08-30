require 'json'
require 'redis'

redis2 = Redis.new
data ={user_name:'kilk', message:'teeeeeest'}

chat_data = redis2.get("global")
#chat_data = {chat: 'global', list: []}  if chat_data.nil?
chat_data = JSON.parse(chat_data)


list = chat_data['list']
p chat_data['list'] = list[-10..-1] if list.size>10
chat_data['list'].each { |el| p el['message']  }
#chat_data =  chat_data.map{|e| JSON.parse(e)}


#chat_data['list'] <<  data
redis2.set("global", chat_data.to_json)
