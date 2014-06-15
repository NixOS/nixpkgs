
{ stdenv
, fetchurl
, zlib ? null
, szip ? null
}:
stdenv.mkDerivation rec {
  version = "1.8.13";
  name = "hdf5-${version}-patch1";
  src = fetchurl {
    url = "http://www.hdfgroup.org/ftp/HDF5/current/src/hdf5-${version}.tar.gz";
    sha256 = "1h9qdl321gzm3ihdhlijbl9sh9qcdrw94j7izg64yfqhxj7b7xl2";  			
  };

  buildInputs = []
    ++ stdenv.lib.optional (zlib != null) zlib
    ++ stdenv.lib.optional (szip != null) szip;

  configureFlags = if szip != null then "--with-szlib=${szip}" else "";
  
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
