data_dir = "data/dennys"

dir.create(data_dir, recursive = TRUE, showWarnings = FALSE)


dennys_url = function(limit=1000, radius=1000, zip)
{    
  paste0('https://hosted.where2getit.com/dennys/responsive/ajax?&xml_request=',
         '<request>',
         '<appkey>6B962D40-03BA-11E5-BC31-9A51842CA48B<%2Fappkey>',
         '<formdata+id%3D"locatorsearch">',
         '<dataview>store_default<%2Fdataview>',
         '<limit>',limit,'<%2Flimit>',
         '<order>rank%2C_distance<%2Forder>',
         '<geolocs>',
         '<geoloc>',
         '<addressline>', zip, '<%2Faddressline>',
         '<longitude><%2Flongitude>',
         '<latitude><%2Flatitude>',
         '<country>US<%2Fcountry>',
         '<%2Fgeoloc>',
         '<%2Fgeolocs>',
         '<stateonly>1<%2Fstateonly>',
         '<searchradius>', radius, '<%2Fsearchradius>',
         '<%2Fformdata>',
         '<%2Frequest>')
}

download.file(dennys_url(zip=64101), file.path(data_dir, paste0(64101,".xml")))
download.file(dennys_url(zip=89101), file.path(data_dir, paste0(89101,".xml")))
download.file(dennys_url(zip=23218), file.path(data_dir, paste0(23218,".xml")))
download.file(dennys_url(radius=800,zip=99501), file.path(data_dir, paste0(99501,".xml")))
download.file(dennys_url(radius=200,zip=96815), file.path(data_dir, paste0(96815,".xml")))