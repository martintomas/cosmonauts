require "factory_bot_rails"
require "faker"

if Rails.env.development?
  FactoryBot.create_list :cosmonaut, 15
end