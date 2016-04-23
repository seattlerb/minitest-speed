require "minitest/autorun"
require "minitest/speed"

module TestMinitest; end

class SpeedTest < Minitest::Test
  include Minitest::Speed

  @@max_setup_time    = 0.01
  @@max_test_time     = 0.01
  @@max_teardown_time = 0.01

  def self.go(&b)
    Class.new(SpeedTest, &b).new(:test_something).run
  end
end

class TestMinitest::TestSpeed < Minitest::Test
  def assert_test_speed(&b)
    refute_predicate SpeedTest.go(&b), :passed?
  end

  def test_slow_setup
    assert_test_speed do
      def setup
        sleep 0.1
      end

      def test_something
        assert true
      end
    end
  end

  def test_slow_test
    assert_test_speed do
      def test_something
        sleep 0.1
      end
    end
  end

  def test_slow_teardown
    assert_test_speed do
      def teardown
        sleep 0.1
      end

      def test_something
        assert true
      end
    end
  end
end
