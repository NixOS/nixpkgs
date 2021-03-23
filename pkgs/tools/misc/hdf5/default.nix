{ lib, stdenv
, fetchurl
, removeReferencesTo
, cpp ? false
, gfortran ? null
, zlib ? null
, szip ? null
, mpiSupport ? false
, mpi
, enableShared ? !stdenv.hostPlatform.isStatic
, javaSupport ? false
, jdk
}:

# cpp and mpi options are mutually exclusive
# (--enable-unsupported could be used to force the build)
assert !cpp || !mpiSupport;

let inherit (lib) optional optionals; in

stdenv.mkDerivation rec {
  version = "1.10.7";
  pname = "hdf5";
  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-1.10/${pname}-${version}/src/${pname}-${version}.tar.bz2";
    sha256 = "0pm5xxry55i0h7wmvc7svzdaa90rnk7h78rrjmnlkz2ygsn8y082";
  };

  passthru = {
    inherit mpiSupport;
    inherit mpi;
  };

  outputs = [ "out" "dev" ];

  nativeBuildInputs = [ removeReferencesTo ];

  buildInputs = []
    ++ optional (gfortran != null) gfortran
    ++ optional (szip != null) szip
    ++ optional javaSupport jdk;

  propagatedBuildInputs = []
    ++ optional (zlib != null) zlib
    ++ optional mpiSupport mpi;

  configureFlags = []
    ++ optional cpp "--enable-cxx"
    ++ optional (gfortran != null) "--enable-fortran"
    ++ optional (szip != null) "--with-szlib=${szip}"
    ++ optionals mpiSupport ["--enable-parallel" "CC=${mpi}/bin/mpicc"]
    ++ optional enableShared "--enable-shared"
    ++ optional javaSupport "--enable-java";

  patches = [
    ./bin-mv.patch
  ];

  postInstall = ''
    find "$out" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
    moveToOutput 'bin/h5cc' "''${!outputDev}"
    moveToOutput 'bin/h5c++' "''${!outputDev}"
    moveToOutput 'bin/h5fc' "''${!outputDev}"
    moveToOutput 'bin/h5pcc' "''${!outputDev}"
  '';

  meta = {
    description = "Data model, library, and file format for storing and managing data";
    longDescription = ''
      HDF5 supports an unlimited variety of datatypes, and is designed for flexible and efficient
      I/O and for high volume and complex data. HDF5 is portable and is extensible, allowing
      applications to evolve in their use of HDF5. The HDF5 Technology suite includes tools and
      applications for managing, manipulating, viewing, and analyzing data in the HDF5 format.
    '';
    license = lib.licenses.bsd3; # Lawrence Berkeley National Labs BSD 3-Clause variant
    homepage = "https://www.hdfgroup.org/HDF5/";
    platforms = lib.platforms.unix;
  };
}
