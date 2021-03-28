{ lib, stdenv
, fetchpatch
, fetchurl
, fixDarwinDylibNames
, cmake
, libjpeg
, uselibtirpc ? stdenv.isLinux
, libtirpc
, zlib
, szip ? null
, javaSupport ? false
, jdk
}:
let
  javabase = "${jdk}/jre/lib/${jdk.architecture}";
in
stdenv.mkDerivation rec {
  pname = "hdf";
  version = "4.2.15";
  src = fetchurl {
    url = "https://support.hdfgroup.org/ftp/HDF/releases/HDF${version}/src/hdf-${version}.tar.bz2";
    sha256 = "04nbgfxyj5jg4d6sr28162cxbfwqgv0sa7vz1ayzvm8wbbpkbq5x";
  };

  patches = [
    # Note that the PPC, SPARC and s390 patches are only needed so the aarch64 patch applies cleanly
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hdf/raw/edbe5f49646b609f5bc9aeeee5a2be47e9556e8c/f/hdf-ppc.patch";
      sha256 = "0dbbfpsvvqzy9zyfv38gd81zzc44gxjib9sd8scxqnkkqprj6jq0";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hdf/raw/edbe5f49646b609f5bc9aeeee5a2be47e9556e8c/f/hdf-4.2.4-sparc.patch";
      sha256 = "0ip4prcjpa404clm87ib7l71605mws54x9492n9pbz5yb51r9aqh";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hdf/raw/edbe5f49646b609f5bc9aeeee5a2be47e9556e8c/f/hdf-s390.patch";
      sha256 = "0aiqbr4s1l19y3r3y4wjd5fkv9cfc8rlr4apbh1p0d57wyvqa7i3";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hdf/raw/edbe5f49646b609f5bc9aeeee5a2be47e9556e8c/f/hdf-arm.patch";
      sha256 = "157k1avvkpf3x89m1fv4a1kgab6k3jv74rskazrmjivgzav4qaw3";
    })
    (fetchpatch {
      url = "https://src.fedoraproject.org/rpms/hdf/raw/edbe5f49646b609f5bc9aeeee5a2be47e9556e8c/f/hdf-aarch64.patch";
      sha256 = "112svcsilk16ybbsi8ywnxfl2p1v44zh3rfn4ijnl8z08vfqrvvs";
    })
  ];

  nativeBuildInputs = [
    cmake
  ] ++ lib.optionals stdenv.isDarwin [
    fixDarwinDylibNames
  ];

  buildInputs = [
    libjpeg
    szip
    zlib
  ]
  ++ lib.optional javaSupport jdk
  ++ lib.optional uselibtirpc libtirpc;

  preConfigure = lib.optionalString uselibtirpc ''
    # Make tirpc discovery work with CMAKE_PREFIX_PATH
    substituteInPlace config/cmake/FindXDR.cmake \
      --replace 'find_path(XDR_INCLUDE_DIR NAMES rpc/types.h PATHS "/usr/include" "/usr/include/tirpc")' \
                'find_path(XDR_INCLUDE_DIR NAMES rpc/types.h PATH_SUFFIXES include/tirpc)'
  '' + lib.optionalString (szip != null) ''
    export SZIP_INSTALL=${szip}
  '';

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
  ] ++ lib.optionals javaSupport [
    "-DHDF4_BUILD_JAVA=ON"
    "-DJAVA_HOME=${jdk}"
    "-DJAVA_AWT_LIBRARY=${javabase}/libawt.so"
    "-DJAVA_JVM_LIBRARY=${javabase}/server/libjvm.so"
  ] ++ lib.optionals (szip != null) [
    "-DHDF4_ENABLE_SZIP_ENCODING=ON"
    "-DHDF4_ENABLE_SZIP_SUPPORT=ON"
  ];

  doCheck = true;

  preCheck = ''
    export LD_LIBRARY_PATH=$(pwd)/bin
  '' + lib.optionalString (stdenv.isDarwin) ''
    export DYLD_LIBRARY_PATH=$(pwd)/bin
  '';

  excludedTests = lib.optionals stdenv.isDarwin [
    "MFHDF_TEST-hdftest"
    "MFHDF_TEST-hdftest-shared"
    "HDP-dumpsds-18"
    "NC_TEST-nctest"
  ];

  checkPhase = let excludedTestsRegex = if (excludedTests != [])
    then "(" + (lib.concatStringsSep "|" excludedTests) + ")"
    else ""; in ''
    runHook preCheck
    ctest -E "${excludedTestsRegex}" --output-on-failure
    runHook postCheck
  '';

  outputs = [ "bin" "dev" "out" ];

  postInstall = ''
    moveToOutput bin "$bin"
  '';

  meta = with lib; {
    description = "Data model, library, and file format for storing and managing data";
    homepage = "https://support.hdfgroup.org/products/hdf4/";
    maintainers = with maintainers; [ knedlsepp ];
    platforms = platforms.unix;
    license = licenses.bsdOriginal;
  };
}
