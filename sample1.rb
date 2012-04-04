require './lib/nml'

nml_file = "./namelists/namelist.wps.all_options"
nml = NML_Reader.read(nml_file)

share=nml[:share].keep :wrf_core, 
           :max_dom,
           :start_date,
           :end_date,
           :interval_seconds,
           :io_form_geogrid
geogrid=nml[:geogrid]
geogrid.del :s_we, :s_sn, :ref_x, :ref_y

ungrib=nml[:ungrib]
metgrid=nml[:metgrid].del(:process_only_bdy,:constants_name,
              :opt_output_from_metgrid_path)

nshare = NML_Group.create(:share)
nshare << share << {:a => 1}
ngrid = NML_Group.create(:geogrid)
ngrid << geogrid
ungrb = NML_Group.create(:ungrib)
ungrb << nml[:ungrib]
nmet = NML_Group.create(:metgrid)
nmet << metgrid

outfil = File.new("namelist.wps.asia","w")
nml_writer = NML_Writer.new
nml_writer << nshare << ngrid << ungrb << nmet
nml_writer >> STDOUT
outfil.close
