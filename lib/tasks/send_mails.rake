require './models/gmail.rb'

include Samples

namespace :reklamer do
  task :send_emails  => :environment do

    result = Samples::send("test send mail")
  end
end
