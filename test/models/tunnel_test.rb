require File.expand_path(File.dirname(__FILE__) + '/../test_config.rb')

class TunnelTest < Test::Unit::TestCase
  context "Tunnel Model" do
    should 'construct new instance' do
      @tunnel = Tunnel.new
      assert_not_nil @tunnel
    end
  end
end
