require './lib/nml'

nml_file = "./namelists/namelist.input"
nml = NML_Reader.read(nml_file)

outfil = File.new("namelist.input.asia","w")
nml_writer = NML_Writer.new
nml_writer << nml
nml_writer >> outfil
outfil.close
nml_writer >> STDOUT
