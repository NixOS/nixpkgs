{ stdenv
, fetchurl
, cpp ? false
, gfortran ? null
, zlib ? null
, szip ? null
, mpi ? null
, enableShared ? true
}:

# cpp and mpi options are mutually exclusive
# (--enable-unsupported could be used to force the build)
assert !cpp || mpi == null;

# No point splitting version 1.8.18 into multiple outputs.
# The library /lib/libhdf5.so has a reference to gcc-wrapper

let inherit (stdenv.lib) optional optionals; in

stdenv.mkDerivation rec {
  version = "1.8.18";
  name = "hdf5-${version}";
  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/${name}/src/${name}.tar.bz2";
    sha256 = "13542vrnl1p35n8vbq0wzk40vddmm33q5nh04j98c7r1yjnxxih1";
 };

  passthru = {
    mpiSupport = (mpi != null);
    inherit mpi;
  };

  buildInputs = []
    ++ optional (gfortran != null) gfortran
    ++ optional (szip != null) szip;

  propagatedBuildInputs = []
    ++ optional (zlib != null) zlib
    ++ optional (mpi != null) mpi;

  configureFlags = []
    ++ optional cpp "--enable-cxx"
    ++ optional (gfortran != null) "--enable-fortran"
    ++ optional (szip != null) "--with-szlib=${szip}"
    ++ optionals (mpi != null) ["--enable-parallel" "CC=${mpi}/bin/mpicc"]
    ++ optional enableShared "--enable-shared";

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
    platforms = stdenv.lib.platforms.unix;
  };
}
