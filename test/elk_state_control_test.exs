defmodule ElkStateControlTest do
  use ExUnit.Case
  doctest ElkStateControl

  test "greets the world" do
    assert ElkStateControl.hello() == :world
  end

  test "simple transit" do
    ss = %SimpleState{state: :state1}
    assert StateProtocol.possible_transit(ss) == [:state2]
  end

  test "simple transit2" do
    ss = %SimpleState{state: :state2}
    assert StateProtocol.possible_transit(ss) == [:state3]
  end

  test "simple transit3" do
    ss = %SimpleState{state: :state3}
    assert StateProtocol.possible_transit(ss) == []
  end

  test "simple transit4" do
    ss = %SimpleState{state: :state3}
    assert StateProtocol.can_transit(ss, :state1) == false
  end

  test "simple transit5" do
    ss = %SimpleState{state: :state3}
    assert StateProtocol.can_transit(ss, :state2) == false
  end

  test "simple transit6" do
    ss = %SimpleState{state: :state3}
    assert StateProtocol.can_transit(ss, :state3) == false
  end

  test "simple transit7" do
    ss = %SimpleState{state: :state2}
    assert StateProtocol.can_transit(ss, :state1) == false
  end

  test "simple transit8" do
    ss = %SimpleState{state: :state2}
    assert StateProtocol.can_transit(ss, :state2) == false
  end

  test "simple transit9" do
    ss = %SimpleState{state: :state2}
    assert StateProtocol.can_transit(ss, :state3) == true
  end

  test "simple transit10" do
    ss = %SimpleState{state: :state1}
    assert StateProtocol.can_transit(ss, :state1) == false
  end

  test "simple transit11" do
    ss = %SimpleState{state: :state1}
    assert StateProtocol.can_transit(ss, :state2) == true
  end

  test "simple transit12" do
    ss = %SimpleState{state: :state1}
    assert StateProtocol.can_transit(ss, :state3) == false
  end

  test "simple transit with event" do
    ss = %SimpleState{
      state: :state1,
      event_map: %{
        state1: fn -> IO.inspect("transit to state1") end,
        state2: fn -> IO.inspect("transit to state2") end,
        state3: fn -> IO.inspect("transit to state3") end
      }
    }

    assert StateProtocol.transit!(ss, :state2).state == :state2
  end

  test "simple transit with event2" do
    ss = %SimpleState{
      state: :state2,
      event_map: %{
        state1: fn -> IO.inspect("transit to state1") end,
        state2: fn -> IO.inspect("transit to state2") end,
        state3: fn -> IO.inspect("transit to state3") end
      }
    }

    assert StateProtocol.transit!(ss, :state3).state == :state3
  end

  test "simple transit with event3" do
    ss = %SimpleState{
      state: :state3,
      event_map: %{
        state1: fn -> IO.inspect("transit to state1") end,
        state2: fn -> IO.inspect("transit to state2") end,
        state3: fn -> IO.inspect("transit to state3") end
      }
    }

    assert_raise RuntimeError, fn ->
      StateProtocol.transit!(ss, :state3)
    end
  end
end
