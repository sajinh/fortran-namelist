module NML_Reader

  def self.lno
    @ln
  end

  def self.read(file)
    nml=IO.readlines(file)
    hash={}
    @ln=0
    loop do 
      line=nml[lno]
      break if line.nil?
      if line.match /^&\s*\w+/
        process(nml,hash) 
      else
        @ln+=1
      end
    end
    hash
  end

  def self.process(nml,hash)
    line = nml[lno].chomp
    key = line[1..-1].to_sym
    hash[key] = NV.new
    loop do
      @ln+=1
      line=nml[lno]
      break if line=~/^\//
      next_line=nml[lno+1]
      if next_line and (not next_line.match /^\//)
        if next_line.match /\s*\w+\s*=/
          key2,val2=process_oneliner(line)
        else
          key2,val2=process_multiliner(nml) #unless next_line.match /^\//
        end
      else
        key2,val2=process_oneliner(line)
      end
      hash[key].merge!({key2.strip.to_sym => val2})
    end
    hash
  end

  def self.process_oneliner(line)
    line.strip!
    key2,val2 = line.split("=")
    val2=process_value(val2)
    return [key2,val2]
  end

  def self.process_multiliner(nml)
    line=nml[lno]
    next_line=nml[lno+1]
    arr=[]
    while !(nml[lno+1].match(/\s*\w+\s*=/))
      break if line=~/^\//
      break if line.nil?
      arr << line
      @ln+=1 
      line=nml[lno]
    end
    line=arr.join
    key2,val2 = line.split("=")
    val2=process_value(val2)
    @ln-=1
    return [key2,val2]
  end
  
  def self.process_value(val2)
    val2.strip!
    val2=val2.chop if val2 =~ /,$/
    # to avoid interpreting .something as method
    return val=val2 if val2.match /\.\w+/ 
    return(eval("val = #{val2}")) 
  end
end
