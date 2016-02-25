Dir[File.expand_path('../lib/*worker.rb', __FILE__)].each(&:require)
require File.expand_path('../boot.rb', __FILE__)
