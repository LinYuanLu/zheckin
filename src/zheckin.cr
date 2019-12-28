require "dotenv"
require "./zheckin/dsl"

env_config = %(#{Zheckin.get_app_env?("env") || "dev"}.env)
Dotenv.load(env_config) if File.exists?(env_config)

require "./zheckin/cli"
require "./zheckin/store"
require "./zheckin/zhihu"
require "./zheckin/logging"
require "./zheckin/web"
require "./zheckin/cron"

Zheckin::CLI.def_action "Zheckin.start"

module Zheckin
  VERSION = "0.1.0"

  def self.start(port, log_level)
    # 初始化日志
    Logging.init(log_level)
    Logging.info "app starting"

    # 定时任务
    spawn { Cron.init }

    # 启动 web 服务
    Web.start(port: port.to_i)
  end
end
