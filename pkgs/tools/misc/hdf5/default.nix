
{ stdenv
, fetchurl
}:
stdenv.mkDerivation {
  name = "hdf5-1.8.10-patch1";
  src = fetchurl {
    url = http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-1.8.10-patch1.tar.gz;
    sha256 = "08ad32fhnci6rdfn6mn3w9v1wcaxdcd326n3ljwkcq4dzhkh28qz";  			
  };
  buildInputs = [] ;
  
  patches = [./bin-mv.patch];
  
  meta = {
    description = "Data model, library, and file format for storing and managing data";
    longDescription = ''
      HDF5 supports an unlimited variety of datatypes, and is designed for flexible and efficient
      I/O and for high volume and complex data. HDF5 is portable and is extensible, allowing 
      applications to evolve in their use of HDF5. The HDF5 Technology suite includes tools and 
      applications for managing, manipulating, viewing, and analyzing data in the HDF5 format.
    '';
    homepage = http://www.hdfgroup.org/HDF5/;
  };
}
