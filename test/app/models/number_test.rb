require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class NumberTest < Test::Unit::TestCase
  context "Number Model" do
    should 'construct new instance' do
      @number = Number.new
      assert_not_nil @number
    end
  end
end
