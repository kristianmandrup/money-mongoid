# encoding: utf-8
class String
  def __evolve_to_money__
    Money.parse(self)
  end
end
