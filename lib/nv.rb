class NV < Hash
  def <<(args)
    self[self.keys.first].merge! (args)
    self
  end

  def del(*args)
    args.flatten.each do |k|
      self.delete(k.to_sym)
    end
    self
  end

  def keep(*args)
    keys=args.flatten
    mesg=["\t*******************************",
          "\t\t method NV#keep",
          "\t One or more keys are invalid",
          "\t Program Aborting for now",
          "\t Try again with valid keys",
          "\t*****************************"].join("\n")
    begin
      vals=keys.map {|k| self.fetch(k)}
    rescue
      abort mesg
    end
    nhsh=NV.new_from_pairs(keys,vals)
    nhsh
  end

  def keep!(*args)
    nil
  end

  def self.new_from_pairs(keys,values)
    hash = NV.new
    keys.size.times { |i| hash[ keys[i] ] = values[i] }
    hash
  end 
end

