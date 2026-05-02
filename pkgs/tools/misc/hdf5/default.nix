{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  removeReferencesTo,
  cppSupport ? true,
  fortranSupport ? false,
  fortran,
  zlibSupport ? true,
  zlib,
  szipSupport ? true,
  libaec,
  mpiSupport ? false,
  mpi,
  enableShared ? !stdenv.hostPlatform.isStatic,
  enableStatic ? stdenv.hostPlatform.isStatic,
  javaSupport ? false,
  jdk,
  apiVersion ? null,
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
  version = "2.1.0";
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
    hash = "sha256-ujZJRZyQ7bpbbwALzxTNobeVsAWNv+hxqj/H26Z4NtA=";
  };

  patches = [
    (fetchpatch {
      name = "reproducible-build.patch";
      url = "https://gitlab.archlinux.org/archlinux/packaging/packages/hdf5/-/raw/721d33408db902ff738db18f1e977611d49b4ba8/hdf5-make-reproducible.patch";
      hash = "sha256-Z31dCsLjYpqjoGXooOXI81EPjPwyTK8890xCENTh8aM=";
    })
  ];

  passthru = {
    inherit
      cppSupport
      fortranSupport
      fortran
      zlibSupport
      zlib
      szipSupport
      libaec
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
    optional fortranSupport fortran ++ optional szipSupport libaec ++ optional javaSupport jdk;

  propagatedBuildInputs = optional zlibSupport zlib ++ optional mpiSupport mpi;

  cmakeFlags = [
    "-DHDF5_INSTALL_CMAKE_DIR=${placeholder "dev"}/lib/cmake"
    (lib.cmakeBool "BUILD_STATIC_LIBS" enableStatic)
    (lib.cmakeBool "BUILD_SHARED_LIBS" enableShared)
    (lib.cmakeBool "HDF5_BUILD_CPP_LIB" cppSupport)
    (lib.cmakeBool "HDF5_BUILD_FORTRAN" fortranSupport)
    (lib.cmakeBool "HDF5_ENABLE_SZIP_SUPPORT" szipSupport)
    (lib.cmakeBool "HDF5_ENABLE_PARALLEL" mpiSupport)
    (lib.cmakeBool "HDF5_BUILD_JAVA" javaSupport)
    (lib.cmakeBool "HDF5_ENABLE_THREADSAFE" threadsafe)
    (lib.cmakeBool "HDF5_BUILD_HL_LIB" (!threadsafe))
    # broken in nixpkgs since around 1.14.3 -> 1.14.4.3
    # https://github.com/HDFGroup/hdf5/issues/4208#issuecomment-2098698567
    (lib.cmakeBool "HDF5_ENABLE_NONSTANDARD_FEATURE_FLOAT16" (
      with stdenv.hostPlatform; !(isDarwin && isx86_64)
    ))
  ]
  ++ lib.optional (apiVersion != null) (lib.cmakeFeature "HDF5_DEFAULT_API_VERSION" apiVersion);

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
  # The shared build creates binaries with -shared suffixes,
  # so we remove these suffixes.
  + lib.optionalString enableShared ''
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

  meta = {
    description = "Data model, library, and file format for storing and managing data";
    longDescription = ''
      HDF5 supports an unlimited variety of datatypes, and is designed for flexible and efficient
      I/O and for high volume and complex data. HDF5 is portable and is extensible, allowing
      applications to evolve in their use of HDF5. The HDF5 Technology suite includes tools and
      applications for managing, manipulating, viewing, and analyzing data in the HDF5 format.
    '';
    license = lib.licenses.bsd3; # Lawrence Berkeley National Labs BSD 3-Clause variant
    maintainers = [ lib.maintainers.markuskowa ];
    homepage = "https://www.hdfgroup.org/HDF5/";
    platforms = lib.platforms.unix;
  };
}
