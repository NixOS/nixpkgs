{ stdenv
, fetchurl
, cmake
, libjpeg
, zlib
, szip ? null
}:

stdenv.mkDerivation rec {
  name = "hdf-${version}";
  version = "4.2.13";
  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF/releases/HDF${version}/src/hdf-${version}.tar.bz2";
    sha256 = "1wz0586zh91pqb95wvr0pbh71a8rz358fdj6n2ksp85x2cis9lsm";
  };

  buildInputs = [
    cmake
    libjpeg
    szip
    zlib
  ];

  preConfigure = stdenv.lib.optionalString (szip != null) "export SZIP_INSTALL=${szip}";

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_TESTING=ON"
    "-DHDF4_BUILD_TOOLS=ON"
    "-DHDF4_BUILD_UTILS=ON"
    "-DHDF4_BUILD_WITH_INSTALL_NAME=OFF"
    "-DHDF4_ENABLE_JPEG_LIB_SUPPORT=ON"
    "-DHDF4_ENABLE_NETCDF=OFF"
    "-DHDF4_ENABLE_Z_LIB_SUPPORT=ON"
    "-DHDF4_BUILD_FORTRAN=OFF"
    "-DJPEG_DIR=${libjpeg}"
  ] ++ stdenv.lib.optionals (szip != null) [
    "-DHDF4_ENABLE_SZIP_ENCODING=ON"
    "-DHDF4_ENABLE_SZIP_SUPPORT=ON"
  ];

  doCheck = true;

  preCheck = ''
    export LD_LIBRARY_PATH=$(pwd)/bin
  '' + stdenv.lib.optionalString (stdenv.isDarwin) ''
    export DYLD_LIBRARY_PATH=$(pwd)/bin
  '';

  excludedTests = [
    "MFHDF_TEST-hdftest"
    "MFHDF_TEST-hdftest-shared"
    "HDP-dumpsds-18"
    "NC_TEST-nctest"
  ];

  checkPhase = let excludedTestsRegex = if (excludedTests != [])
    then "(" + (stdenv.lib.concatStringsSep "|" excludedTests) + ")"
    else ""; in ''
    runHook preCheck
    ctest -E "${excludedTestsRegex}" --output-on-failure
    runHook postCheck
  '';

  outputs = [ "bin" "dev" "out" ];

  postInstall = ''
    moveToOutput bin "$bin"
  '';

  meta = {
    description = "Data model, library, and file format for storing and managing data";
    homepage = https://support.hdfgroup.org/products/hdf4/;
    maintainers = with stdenv.lib.maintainers; [ knedlsepp ];
    platforms = stdenv.lib.platforms.unix;
  };
}
