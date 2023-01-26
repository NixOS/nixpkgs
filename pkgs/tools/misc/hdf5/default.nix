{ lib
, stdenv
, fetchurl
, cmake
, cppSupport ? false
, fortranSupport ? false
, fortran
, zlibSupport ? true
, zlib
, szipSupport ? false
, szip
, mpiSupport ? false
, mpi
, javaSupport ? false
, jdk
, usev110Api ? false
, threadsafe ? false
, enableShared ? !stdenv.hostPlatform.isStatic
, enableStatic ? stdenv.hostPlatform.isStatic
}:

assert !(cppSupport && mpiSupport);
assert !(cppSupport && threadsafe);
assert !(fortranSupport && threadsafe);
assert enableShared || enableStatic;

stdenv.mkDerivation rec {
  pname = "hdf5";
  version = "1.14.0";

  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF5/releases/hdf5-${lib.versions.majorMinor version}/hdf5-${version}/src/hdf5-${version}.tar.bz2";
    hash = "sha256-5OeUM0UO2uKGWkxjKBiLtFORsp10+MU47mmfCxFsK6A=";
  };

  outputs = [ "out" "dev" ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ] ++
    lib.optional fortranSupport fortran ++
    lib.optional javaSupport jdk;

  propagatedBuildInputs = [ ] ++
    lib.optional zlibSupport zlib ++
    lib.optional szipSupport szip ++
    lib.optional mpiSupport mpi;

  # https://github.com/HDFGroup/hdf5/blob/hdf5-1_14_0/release_docs/INSTALL_CMake.txt
  cmakeFlags = [ ] ++
    lib.optional usev110Api "-DDEFAULT_API_VERSION=v110" ++
    lib.optional cppSupport "-DHDF5_BUILD_CPP_LIB=ON" ++
    lib.optional fortranSupport "-DHDF5_BUILD_FORTRAN=ON" ++
    lib.optional javaSupport "-DHDF5_BUILD_JAVA=ON" ++
    lib.optional mpiSupport "-DHDF5_ENABLE_PARALLEL=ON" ++
    lib.optional threadsafe "-DHDF5_ENABLE_THREADSAFE=ON" ++
    lib.optional zlibSupport "-DHDF5_ENABLE_Z_LIB_SUPPORT=ON" ++
    lib.optional szipSupport "-DHDF5_ENABLE_SZIP_SUPPORT=ON" ++
    # BUILD_SHARED_LIBS and BUILD_STATIC_LIBS are on by default
    lib.optional (!enableShared) "-DBUILD_SHARED_LIBS=OFF" ++
    lib.optional (!enableStatic) "-DBUILD_STATIC_LIBS=OFF" ++
    lib.optional enableStatic "-DBUILD_STATIC_EXECS";

  # mpi does not run well in nix sandbox
  doCheck = !mpiSupport;

  passthru = {
    inherit
      cppSupport
      fortranSupport
      fortran
      zlibSupport
      szipSupport
      mpiSupport
      mpi;
  };

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
    maintainers = with lib.maintainers; [ nickcao ];
  };
}
