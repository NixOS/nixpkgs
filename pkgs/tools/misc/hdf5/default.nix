
{ stdenv
, fetchurl
}:
stdenv.mkDerivation {
  name = "hdf5";
  src = fetchurl {
    url = http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.5.tar.gz ;
    sha256 = "0nykbpxg154akgp6va6fkab7kjvybbvpsr7n7i1l8xxmv3h3hbsa";  			
  };
  buildInputs = [] ;
  
  patches = [./bin-mv.patch];
  
  meta = {
    description = "HDF5 is a data model, library, and file format for storing and managing data.";
    longDescription = ''
      It supports an unlimited variety of datatypes, and is designed for flexible and efficient 
      I/O and for high volume and complex data. HDF5 is portable and is extensible, allowing 
      applications to evolve in their use of HDF5. The HDF5 Technology suite includes tools and 
      applications for managing, manipulating, viewing, and analyzing data in the HDF5 format.
    '';
    homepage = http://www.hdfgroup.org/HDF5/;
    # license = "GPLv2";
  };
}
