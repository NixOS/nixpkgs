{ stdenv
, fetchurl
, gcc
, removeReferencesTo
, cpp ? false
, gfortran ? null
, fortran2003 ? false
, zlib ? null
, szip ? null
, mpi ? null
, enableShared ? true
}:

# cpp and mpi options are mutually exclusive
# (--enable-unsupported could be used to force the build)
assert !cpp || mpi == null;

# Need a Fortran compiler for Fortran2003 bindings
assert fortran2003 -> gfortran != null;

# No point splitting version 1.8.18 into multiple outputs.
# The library /lib/libhdf5.so has a reference to gcc-wrapper

let inherit (stdenv.lib) optional optionals; in

stdenv.mkDerivation rec {
  version = "1.8.19";
  name = "hdf5-${version}";
  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.8/${name}/src/${name}.tar.bz2";
    sha256 = "0f3jfbqpaaq21ighi40qzs52nb52kc2d2yjk541rjmsx20b3ih2r" ;
 };

  passthru = {
    mpiSupport = (mpi != null);
    inherit mpi;
  };

  nativeBuildInputs = [ removeReferencesTo ];

  buildInputs = []
    ++ optional (gfortran != null) gfortran
    ++ optional (szip != null) szip;

  propagatedBuildInputs = []
    ++ optional (zlib != null) zlib
    ++ optional (mpi != null) mpi;

  configureFlags = []
    ++ optional cpp "--enable-cxx"
    ++ optional (gfortran != null) "--enable-fortran"
    ++ optional fortran2003 "--enable-fortran2003"
    ++ optional (szip != null) "--with-szlib=${szip}"
    ++ optionals (mpi != null) ["--enable-parallel" "CC=${mpi}/bin/mpicc"]
    ++ optional enableShared "--enable-shared";

  patches = [./bin-mv.patch];

  postInstall = ''
    find "$out" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
  '';

  meta = {
    description = "Data model, library, and file format for storing and managing data";
    longDescription = ''
      HDF5 supports an unlimited variety of datatypes, and is designed for flexible and efficient
      I/O and for high volume and complex data. HDF5 is portable and is extensible, allowing
      applications to evolve in their use of HDF5. The HDF5 Technology suite includes tools and
      applications for managing, manipulating, viewing, and analyzing data in the HDF5 format.
    '';
    license = stdenv.lib.licenses.free; # BSD-like
    homepage = https://www.hdfgroup.org/HDF5/;
    platforms = stdenv.lib.platforms.unix;
    broken = (gfortran != null) && stdenv.isDarwin;
  };
}
