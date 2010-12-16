
{ stdenv
, fetchurl
}:
stdenv.mkDerivation {
  name = "hdf5";
  src = fetchurl {
    url = http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.5-patch1.tar.gz ;
    sha256 = "919bb52a08fc5560c49fdc5ebd693b10b1e03eebbf44ad2e142c2e6cfd81f2b0";  			
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
  };
}
