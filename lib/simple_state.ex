defmodule SimpleState do
  defstruct [:state, :event_map]

  defimpl StateProtocol do
    def all_state(_) do
      [:state1, :state2, :state3]
    end

    def can_transit(ss, state) do
      can_transit_internal(ss.state, state)
    end

    def possible_transit(ss) do
      Enum.filter(all_state(ss), fn state ->
        can_transit_internal(ss.state, state)
      end)
    end

    def transit!(ss, next_state) do
      if can_transit_internal(ss.state, next_state) do
        fire_event(ss, next_state)
        %{state: next_state}
      else
        raise "Can't transit from #{ss.state} to #{next_state}"
      end
    end

    def fire_event(ss, state) do
      find_and_fire_fn(ss, state)
    end

    defp find_and_fire_fn(ss, state) do
      event = Map.get(ss.event_map, state, fn -> raise "Unknown event" end)
      event.()
    end

    defp can_transit_internal(:state1, :state2), do: true

    defp can_transit_internal(:state2, :state3), do: true

    defp can_transit_internal(_, _), do: false
  end
end
