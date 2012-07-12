require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class PhoneTest < Test::Unit::TestCase
  context "Phone Model" do
    should 'construct new instance' do
      @phone = Phone.new
      assert_not_nil @phone
    end
  end
end
