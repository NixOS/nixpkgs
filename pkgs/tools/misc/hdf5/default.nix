{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  removeReferencesTo,
  cppSupport ? true,
  fortranSupport ? false,
  fortran,
  zlibSupport ? true,
  zlib,
  szipSupport ? false,
  szip,
  mpiSupport ? false,
  mpi,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  javaSupport ? false,
  jdk,
  usev110Api ? false,
  threadsafe ? false,
  python3,
}:

# cpp and mpi options are mutually exclusive
# "-DALLOW_UNSUPPORTED=ON" could be used to force the build.
assert !cppSupport || !mpiSupport;

let
  inherit (lib) optional optionals;
in

stdenv.mkDerivation rec {
  version = "1.14.6";
  pname =
    "hdf5"
    + lib.optionalString cppSupport "-cpp"
    + lib.optionalString fortranSupport "-fortran"
    + lib.optionalString mpiSupport "-mpi"
    + lib.optionalString threadsafe "-threadsafe";

  src = fetchFromGitHub {
    owner = "HDFGroup";
    repo = "hdf5";
    rev = "hdf5_${version}";
    hash = "sha256-mJTax+VWAL3Amkq3Ij8fxazY2nfpMOTxYMUQlTvY/rg=";
  };

  passthru = {
    inherit
      cppSupport
      fortranSupport
      fortran
      zlibSupport
      zlib
      szipSupport
      szip
      mpiSupport
      mpi
      ;
  };

  outputs = [
    "out"
    "dev"
    "bin"
  ];

  nativeBuildInputs = [
    removeReferencesTo
    cmake
  ]
  ++ optional fortranSupport fortran;

  buildInputs =
    optional fortranSupport fortran ++ optional szipSupport szip ++ optional javaSupport jdk;

  propagatedBuildInputs = optional zlibSupport zlib ++ optional mpiSupport mpi;

  cmakeFlags = [
    "-DHDF5_INSTALL_CMAKE_DIR=${placeholder "dev"}/lib/cmake"
    "-DBUILD_STATIC_LIBS=${lib.boolToString enableStatic}"
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin "-DHDF5_BUILD_WITH_INSTALL_NAME=ON"
  ++ lib.optional cppSupport "-DHDF5_BUILD_CPP_LIB=ON"
  ++ lib.optional fortranSupport "-DHDF5_BUILD_FORTRAN=ON"
  ++ lib.optional szipSupport "-DHDF5_ENABLE_SZIP_SUPPORT=ON"
  ++ lib.optionals mpiSupport [ "-DHDF5_ENABLE_PARALLEL=ON" ]
  ++ lib.optional enableShared "-DBUILD_SHARED_LIBS=ON"
  ++ lib.optional javaSupport "-DHDF5_BUILD_JAVA=ON"
  ++ lib.optional usev110Api "-DDEFAULT_API_VERSION=v110"
  ++ lib.optionals threadsafe [
    "-DHDF5_ENABLE_THREADSAFE:BOOL=ON"
    "-DHDF5_BUILD_HL_LIB=OFF"
  ]
  # broken in nixpkgs since around 1.14.3 -> 1.14.4.3
  # https://github.com/HDFGroup/hdf5/issues/4208#issuecomment-2098698567
  ++ lib.optional (
    stdenv.hostPlatform.isDarwin && stdenv.hostPlatform.isx86_64
  ) "-DHDF5_ENABLE_NONSTANDARD_FEATURE_FLOAT16=OFF";

  postInstall = ''
    find "$out" -type f -exec remove-references-to -t ${stdenv.cc} '{}' +
    moveToOutput 'bin/' "''${!outputBin}"
    moveToOutput 'bin/h5cc' "''${!outputDev}"
    moveToOutput 'bin/h5c++' "''${!outputDev}"
    moveToOutput 'bin/h5fc' "''${!outputDev}"
    moveToOutput 'bin/h5pcc' "''${!outputDev}"
    moveToOutput 'bin/h5hlcc' "''${!outputDev}"
    moveToOutput 'bin/h5hlc++' "''${!outputDev}"
  ''
  +
    lib.optionalString enableShared
      # The shared build creates binaries with -shared suffixes,
      # so we remove these suffixes.
      ''
        pushd ''${!outputBin}/bin
        for file in *-shared; do
          mv "$file" "''${file%%-shared}"
        done
        popd
      ''
  + lib.optionalString fortranSupport ''
    mv $out/mod/shared $dev/include
    rm -r $out/mod

    find "$out" -type f -exec remove-references-to -t ${fortran} '{}' +
  '';

  enableParallelBuilding = true;

  passthru.tests = {
    inherit (python3.pkgs) h5py;
  };

  meta = with lib; {
    description = "Data model, library, and file format for storing and managing data";
    longDescription = ''
      HDF5 supports an unlimited variety of datatypes, and is designed for flexible and efficient
      I/O and for high volume and complex data. HDF5 is portable and is extensible, allowing
      applications to evolve in their use of HDF5. The HDF5 Technology suite includes tools and
      applications for managing, manipulating, viewing, and analyzing data in the HDF5 format.
    '';
    license = licenses.bsd3; # Lawrence Berkeley National Labs BSD 3-Clause variant
    maintainers = [ maintainers.markuskowa ];
    homepage = "https://www.hdfgroup.org/HDF5/";
    platforms = platforms.unix;
  };
}
