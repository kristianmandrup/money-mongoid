class Array
  def exchange_to! currency
    self.map!{|m| m.exchange_to!(currency) }
  end
end