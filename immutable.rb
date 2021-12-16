class Symbol
  def as_msym
    ('@' + self.to_s).to_sym
  end
end

def immutable(*mbs)
  if self.class == Object
    return
  end

  mbs.each do |mb|
    define_method(mb) do
      instance_variable_get(mb.as_msym)
    end
  end
  
  self.class_variable_set('@@members', mbs)
  
  define_method(:initialize) do |*args|
    throw('constructor arg length error') unless args.length == self.class.class_variable_get('@@members').count
    l_membs = self.class.class_variable_get('@@members').clone
    args.each do |arg|
      instance_variable_set(l_membs.shift.as_msym, arg)
    end
    self.freeze
  end
end

class Test
  immutable(:a, :b)

  def with_a(new_a)
    self.class.new(new_a, self.b)
  end

  def with_b(new_b)
    self.class.new(self.a, new_b)
  end
end
