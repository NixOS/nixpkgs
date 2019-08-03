{ stdenv
, fetchpatch
, fetchurl
, cmake
, libjpeg
, zlib
, szip ? null
}:

stdenv.mkDerivation rec {
  name = "hdf-${version}";
  version = "4.2.14";
  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF/releases/HDF${version}/src/hdf-${version}.tar.bz2";
    sha256 = "0n29klrrbwan9307np0d9hr128dlpc4nnlf57a140080ll3jmp8l";
  };

  patches = let
    # The Debian patch revision to fetch from; this may differ from our package
    # version, but older patches should still apply.
    patchRev = "4.2.13-4";
    getPatch = name: sha256: fetchpatch {
      inherit sha256;
      url = "https://salsa.debian.org/debian-gis-team/hdf4/raw/debian/${patchRev}/debian/patches/${name}";
    };

  in [
    (getPatch "64bit"                     "1xqk9zpch4m6ipa0f3x2cm8rwaz4p0ppp1vqglvz18j6q91p8b5y")
    (getPatch "hdfi.h"                    "01fr9csylnvk9jd9jn9y23bvxy192s07p32pr76mm3gwhgs9h7r4")
    (getPatch "hdf-4.2.10-aarch64.patch"  "1hl0xw5pd9xhpq49xpwgg7c4z6vv5p19x6qayixw0myvgwj1r4zn")
    (getPatch "reproducible-builds.patch" "02j639w26xkxpxx3pdhbi18ywz8w3qmjpqjb83n47gq29y4g13hc")
  ];

  buildInputs = [
    cmake
    libjpeg
    szip
    zlib
  ];

  preConfigure = stdenv.lib.optionalString (szip != null) "export SZIP_INSTALL=${szip}";

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
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

  excludedTests = stdenv.lib.optionals stdenv.isDarwin [
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
