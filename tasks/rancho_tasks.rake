namespace :rancho do
    
    desc 'Sets up parolkar\'s rancho plugin '
    task :setup do
      
      
      
      files_to_be_copied = [
        {:source => "/vendor/plugins/rancho/migrations/01_create_rancho_content_pointer.rb", :target => "/db/migrate/#{migration_timestamp}_create_rancho_content_pointer.rb" },
        {:source => "/vendor/plugins/rancho/migrations/02_create_rancho_index.rb", :target => "/db/migrate/#{migration_timestamp}_create_rancho_index.rb" },
        {:source => "/vendor/plugins/rancho/migrations/03_create_rancho_word.rb", :target => "/db/migrate/#{migration_timestamp}_create_rancho_word.rb" }
        ]
      
      root = "#{Rails.root}"
      FileUtils.mkdir_p("#{root}/db/migrate") unless File.exists?("#{root}/db/migrate")
      files_to_be_copied.each {|ftbc|
        FileUtils.cp_r(root+ftbc[:source], root+ftbc[:target]) #:force => true)
        puts "Created : #{ftbc[:target]}"
      }
      
      puts "Running \"rake db:migrate\" for you..."
      Rake::Task["db:migrate"].invoke
      
      welcome_screen
     
    end
 
    def migration_timestamp   
      sleep (1)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end  
    
    def welcome_screen
    
    mesg = <<HERE
Congratulations for setting up Rancho plugin! Enjoy the search :-)


HERE

    puts mesg      
    end
    
end
