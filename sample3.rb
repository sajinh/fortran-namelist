require './lib/nml'

nml_file = "./namelists/namelist.input"
nml = NML_Reader.read(nml_file)


nml[:time_control].keep :run_hours
nml.delete(:domains)
nml.delete(:physics)
nml.delete(:fdda)
nml.delete(:dynamics)
nml.delete(:bdy_control)
nml.delete(:grib2)


nml_writer = NML_Writer.new
nml_writer << nml
nml_writer >> STDOUT
