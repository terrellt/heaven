module Heaven
  module Notifier
    class Irc < Notifier::Default
      def deliver(msg)
        msg << " #{output_link('Output')}"
        Rails.logger.info "irc: #{msg}"
        uri = URI.parse("#{message_url}/#{URI.escape(chat_room)}")
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Post.new(uri.request_uri)
        request.set_form_data({:payload => request_data(msg).to_json})
        http.request(request)
      end

      def request_data(msg)
        {
          :token => message_token,
          :msg => msg
        }
      end

      def message_token
        ENV['HUBOT_IRC_MESSAGE_TOKEN'] || ''
      end

      def message_url
        ENV['HUBOT_IRC_MESSAGE_URL'] || ''
      end
    end
  end
end
