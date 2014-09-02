module Provider
  class Capistrano < DefaultProvider
    attr_accessor :last_child

    def initialize(guid, payload)
      super
      @name = "capistrano"
    end

    def move_config
      if File.exists?(config_folder)
        log "Moving configuration from #{config_folder} to #{checkout_directory}."
        FileUtils.cp_r(Dir["#{config_folder.to_s}/**/*"], Pathname.new(checkout_directory.to_s).join("config"), :verbose => true)
      else
        log "No config folder #{config_folder}"
      end
    end

    def config_folder
      Rails.root.join("config/site_configs/#{name.split("/").last.gsub("-","").downcase}")
    end

    def cap_path
      gem_executable_path("cap")
    end

    def task
      name = custom_payload && custom_payload['task'] || 'deploy'
      unless name =~ /deploy(?:\:[\w+:]+)?/
        raise StandardError "Invalid capistrano taskname: #{name.inspect}"
      end
      name
    end

    def execute_and_log(cmds)
      @last_child = POSIX::Spawn::Child.new({"HOME"=>working_directory},*cmds)
      log_stdout(last_child.out)
      log_stderr(last_child.err)
      last_child
    end

    def execute
      return execute_and_log(["/usr/bin/true"]) if Rails.env.test?

      unless File.exists?(checkout_directory)
        log "Cloning #{repository_url} into #{checkout_directory}"
        execute_and_log(["git", "clone", clone_url, checkout_directory])
      end
      move_config

      Dir.chdir(checkout_directory) do
        log "Fetching the latest code"
        execute_and_log(["git", "fetch"])
        execute_and_log(["git", "reset", "--hard", sha])
        deploy_string = [ cap_path, environment, "-s", "branch=#{ref}", task ]
        log "Executing capistrano: #{deploy_string.join(' ')}"
        execute_and_log(deploy_string)
      end
    end

    def notify
      output.stderr = File.read(stderr_file)
      output.stdout = File.read(stdout_file)
      output.update
      if last_child.success?
        status.success!
      else
        status.failure!
      end
    end
  end
end
