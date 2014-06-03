module Sorcery
  module TestHelpers
    module Rails
      def login_user_page(mail, password)
        page.driver.post('/user_sessions', { email: mail, password: password}) 
      end

      def logout_user_page
         page.driver.get('/logout')
      end

      def login_user_post(mail, password)
        post '/user_sessions', email: mail, password: password 
      end
    end
  end
end