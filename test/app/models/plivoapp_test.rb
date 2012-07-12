require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class PlivoappTest < Test::Unit::TestCase
  context "Plivoapp Model" do
    should 'construct new instance' do
      @plivoapp = Plivoapp.new
      assert_not_nil @plivoapp
    end
  end
end
