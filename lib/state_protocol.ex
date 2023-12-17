defprotocol StateProtocol do
  def all_state(state)

  def can_transit(current_state, next_state)

  def possible_transit(current_state)

  def transit!(current_state, next_state)

  def fire_event(current_state, next_state)
end
