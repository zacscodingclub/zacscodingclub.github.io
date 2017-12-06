class Deploy
  class << self
    def build
      command = "jekyll build"
      puts "Build Started"
      exec(command)
      puts "Build Complete"
    end

    def remote_sync
      command = "rsync ./_site zeebee@beorn.dreamhost.com:/home/zeebee/zacbaston.com"
      puts "Deploying to Dreamhost"
      exec(command)

    end

    def call
      begin
        build
        remote_sync
      rescue Exception => e
        puts "Error: #{e}"
      end
    end
  end
end

Deploy.call
