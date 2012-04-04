
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
  def initialize
   @hash=NV[:nml, {}]
  end

  def <<(args)
    @hash<<(args)
  end

  def nml
    arr=[]
    nml=@hash[:nml]
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
    args.puts nml
  end
end
