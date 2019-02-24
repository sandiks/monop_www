Monopwww::App.controllers :account do

    get :index do

    end
    get :new do
        LogHelper.log_req(request)

        render 'new'
    end
    post :create do
        name =params[:name]
        users = Monopwww::App.cache['site_users'] || []
        if !users.any? {|u| u[:name] == name}
            rec = {name: name, email: "#{name}@ggmail.com", pass:params[:password], created_at: Time.now.to_i}
            users << rec
            Users.insert(rec) 
            Monopwww::App.cache['site_users'] = users
            
            flash[:success] = "зарегистрировались успешно, теперь вы можете войти"
            redirect url(:sessions, :login)
        else
            flash[:error] = "такой игрок уже существует"
            redirect url(:account, :new)
        end

    end
end
