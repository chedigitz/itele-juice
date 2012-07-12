require File.expand_path(File.dirname(__FILE__) + '/../../test_config.rb')

class LlamadaTest < Test::Unit::TestCase
  context "Llamada Model" do
    should 'construct new instance' do
      @llamada = Llamada.new
      assert_not_nil @llamada
    end
  end
end
