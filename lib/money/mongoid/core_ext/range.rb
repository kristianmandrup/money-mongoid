class Range
  def dollars
    ::MoneyRange.new self, 'usd'
  end

  def euros
    ::MoneyRange.new self, 'eur'
  end

  def to_currency iso_code
    ::MoneyRange.new self, iso_code
  end
end

class Money
  def self.range range, iso_code
    ::MoneyRange.new range, iso_code
  end
end

class MoneyRange < DelegateDecorator
  attr_reader :iso_code, :range

  def initialize range, iso_code
    super(range)
    @range = range
    @iso_code = iso_code
  end
end

