require './lib/nml'

nml_file = "./namelists/namelist.input"
nml = NML_Reader.read(nml_file)

outfil = File.new("namelist.input.asia","w")
NML_Writer << nml
NML_Writer >> outfil
outfil.close
NML_Writer >> STDOUT
