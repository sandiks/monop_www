# Helper methods defined here can be accessed in any controller or view in the application

module SiteHelper
    def self.chat_messages
        redis = Redis.new
        chat_data = redis.get("global")
        chat_data = {chat: 'global', list: []}.to_json  if chat_data.nil?
        JSON.parse(chat_data)
    end
end


module LogHelper
    def self.log_req(req)
        #p req.path
        #incld = req.path.include?('/actualfile.aspx') || req.user_agent.include?('X11; Linux x86_64')

        rec = {:path=> req.path, :ip=> req.ip, :referer=> req.referer,  :date => DateTime.now.new_offset(3/24.0), :uagent=> req.user_agent }
        Logs.insert(rec)
        #Monopwww::App.cache['site_logs']<< rec
    end

    def self.date_now_tz3
        DateTime.now.new_offset(3/24.0)
    end


end
