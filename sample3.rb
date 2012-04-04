require './lib/nml'

nml_file = "./namelists/namelist.input"
nml = NML_Reader.read(nml_file)
nml[:time_control].del :run_days
nml.delete(:domains)
nml.delete(:physics)
nml.delete(:fdda)
nml.delete(:dynamics)
nml.delete(:bdy_control)
nml.delete(:grib2)


NML_Writer << nml
NML_Writer >> STDOUT
