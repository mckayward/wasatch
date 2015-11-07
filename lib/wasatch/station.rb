class Station

  attr_reader :name, :mile, :elevation
  attr_accessor :in, :out

  def initialize(row)
    @name       = row[0].text
    @mile       = row[1].text
    @elevation  = row[2].text
    @in         = row[3].text
    @out        = row[4].text
  end

  def ==(otherstation)
    @in == otherstation.in && @out == otherstation.out
  end

  def to_s
    "#{@name}: IN:#{@in} OUT:#{@out}"
  end
end
