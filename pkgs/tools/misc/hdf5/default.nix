{ stdenv
, fetchurl
, removeReferencesTo
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

let inherit (stdenv.lib) optional optionals; in

stdenv.mkDerivation rec {
  version = "1.10.4";
  name = "hdf5-${version}";
  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/${name}/src/${name}.tar.bz2";
    sha256 = "1pr85fa1sh2ky6ai2hs3f21lp252grl2cq3wbyi4rh7dm83gyrqj";
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
    ++ optional (szip != null) "--with-szlib=${szip}"
    ++ optionals (mpi != null) ["--enable-parallel" "CC=${mpi}/bin/mpicc"]
    ++ optional enableShared "--enable-shared";

  patches = [
    ./bin-mv.patch
    # upstream patches for openmpi-4 compatiblity
    # To be removed with the upgrade to 1.10.5
    ./0001-Updated-H5S-to-use-the-MPI-2-function-MPI_Type_get_e.patch
    ./0001-Yanked-all-MPI-1-calls.patch
  ];

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
    license = stdenv.lib.licenses.bsd3; # Lawrence Berkeley National Labs BSD 3-Clause variant
    homepage = https://www.hdfgroup.org/HDF5/;
    platforms = stdenv.lib.platforms.unix;
    broken = (gfortran != null) && stdenv.isDarwin;
  };
}
