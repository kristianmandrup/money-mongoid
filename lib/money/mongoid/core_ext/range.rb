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

# http://blog.jayfields.com/2008/02/ruby-replace-methodmissing-with-dynamic.html
class DelegateDecorator
  def initialize(subject)
    subject.public_methods(false).each do |meth|
      (class << self; self; end).class_eval do
        define_method meth do |*args|
          subject.send meth, *args
        end
      end
    end
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

