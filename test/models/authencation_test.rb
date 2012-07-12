require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class AuthencationTest < Test::Unit::TestCase
  context "Authencation Model" do
    should 'construct new instance' do
      @authencation = Authencation.new
      assert_not_nil @authencation
    end
  end
end
