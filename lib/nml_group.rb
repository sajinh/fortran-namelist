
module NML_Group
  def self.create(name)
    NV[name.to_sym,  {}]
  end

end

#class NV < Hash
#  def <<(args)
#    self[self.keys.first].merge! (args)
#    self
#  end
#end

class NML_Writer 
  attr_accessor :okeys
  def initialize
    @hash=NV[:nml, {}]
    @okeys=[]
  end

  def <<(args)
    args.keys.each {|k| @okeys << k}
    @hash<<(args)
  end

  def ohash(nml)
    ohash=nml
    if ohash.keys.any? {|k| !okeys.index(k)}
      ohash.to_a
    else
      ohash.keys.each {|k| ohash[k].merge!(:____idx____=>okeys.index(k))}
      ohash.sort_by {|k,v| v[:____idx____]}
    end
  end

  def onml
    arr=[]
    tmp=@hash[:nml]
    tmp.delete(:okeys) if tmp.has_key? :okeys
    oarr= ohash(tmp)
    oarr.each do |a|
      k=a[0]
      arr<<"&#{k}"
       a[1].delete(:____idx____)
       a[1].each_pair do |ky,vl|
         if vl.is_a? Array
           if vl.any? {|w| w.is_a? String}
             vl=vl.map {|w| "'#{w}'"}.join(",")
           else
             vl=vl.join(",") 
           end
         else
           vl="'#{vl}'" if vl.is_a? String and !vl.match(/\.\w+/)
         end

         arr<<" #{ky} = #{vl},"
       end
       arr<<"/"
       arr<<"\n"
    end
   arr[0..-2] # remove the last line space
  end

  def nml
    arr=[]
    nml=@hash[:nml]
    nml.delete(:okeys) if nml.has_key? :okeys
    nml.keys.each do |k|
      arr<<"&#{k}"
       nml[k].each_pair do |ky,vl|
         if vl.is_a? Array
           if vl.any? {|w| w.is_a? String}
             vl=vl.map {|w| "'#{w}'"}.join(",")
           else
             vl=vl.join(",") 
           end
         else
           vl="'#{vl}'" if vl.is_a? String and !vl.match(/\.\w+/)
         end

         arr<<" #{ky} = #{vl},"
       end
       arr<<"/"
       arr<<"\n"
    end
   arr[0..-2] # remove the last line space
  end

  def >>(args)
    args.puts onml
  end
end
