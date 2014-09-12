require 'heaven/notifier/default'
require 'heaven/notifier/campfire'
require 'heaven/notifier/hipchat'
require 'heaven/notifier/flowdock'
require 'heaven/notifier/slack'
require 'heaven/notifier/irc'

module Heaven
  module Notifier
    def self.for(payload)
      if slack?(payload)
        ::Heaven::Notifier::Slack.new(payload)
      elsif hipchat?
        ::Heaven::Notifier::Hipchat.new(payload)
      elsif flowdock?
        ::Heaven::Notifier::Flowdock.new(payload)
      elsif irc?
        ::Heaven::Notifier::Irc.new(payload)
      elsif Rails.env.test?
        # noop on posting
      else
        ::Heaven::Notifier::Campfire.new(payload)
      end
    end

    def self.slack?(payload={"notify" => {}})
      Rails.logger.info "Full Payload: #{payload}"
      Rails.logger.info "Payload: #{payload["notify"]["adapter"]}"
      !!ENV['SLACK_TOKEN'] && payload["notify"]["adapter"] == "slack"
    end

    def self.irc?
      !!ENV['HUBOT_IRC_MESSAGE_TOKEN']
    end

    def self.hipchat?
      !!ENV['HIPCHAT_TOKEN']
    end

    def self.flowdock?
      !!ENV['FLOWDOCK_FLOW_API_TOKEN']
    end
  end
end
