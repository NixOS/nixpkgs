{ stdenv
, fetchurl
, cmake
, file
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

with { inherit (stdenv.lib) optional optionals; };

stdenv.mkDerivation rec {
  version = "1.8.16";
  name = "hdf5-${version}";
  src = fetchurl {
    url = "http://www.hdfgroup.org/ftp/HDF5/releases/${name}/src/${name}.tar.bz2";
    sha256 = "1ilq8pn9lxbf2wj2rdzwqabxismznjj1d23iw6g78w0bl5dsxahk";
  };

  patches = [ ./hl-H5LDpublic.patch ];

  passthru = {
    mpiSupport = (mpi != null);
    inherit mpi;
  };

  buildInputs = [ cmake ]
    ++ optional (gfortran != null) gfortran
    ++ optional (szip != null) szip;

  propagatedBuildInputs = []
    ++ optional (zlib != null) zlib
    ++ optional (mpi != null) mpi;

  cmakeFlags = [
    "-DCMAKE_BUILD_TYPE=Release"
    "-DCMAKE_C_FLAGS=-fPIC"
    "-DHDF5_BUILD_HL_LIB=ON"
    "-DHDF5_DISABLE_COMPILER_WARNINGS=ON"
    "-DHDF5_BUILD_TOOLS=ON"
    "-DCMAKE_EXE_LINKER_FLAGS=''"
    "-DHDF5_INSTALL_DATA_DIR=share/hdf5"
    "-DHDF5_INSTALL_CMAKE_DIR=share/cmake/hdf5"
  ]
    ++ stdenv.lib.optional (mpi != null)  "-DHDF5_ENABLE_PARALLEL=ON -DHDF5_BUILD_CPP_LIB:BOOL=OFF"
    ++ stdenv.lib.optional (zlib != null) "-DHDF5_ENABLE_Z_LIB_SUPPORT:BOOL=ON"
    ++ stdenv.lib.optionals (gfortran != null) [
      "-DHDF5_BUILD_FORTRAN=ON"
      "-DHDF5_ENABLE_F2003=ON"
  ]
  ;

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
