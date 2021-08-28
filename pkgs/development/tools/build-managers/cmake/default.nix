{ stdenv, lib, fetchurl, pkg-config
, bzip2, curlMinimal, expat, libarchive, xz, zlib, libuv, rhash
, buildPackages
# darwin attributes
, ps
, isBootstrap ? false
, useSharedLibraries ? (!isBootstrap && !stdenv.isCygwin)
, useOpenSSL ? !isBootstrap, openssl
, useNcurses ? false, ncurses
, withQt5 ? false, qtbase
}:

stdenv.mkDerivation (rec {
  pname = "cmake"
          + lib.optionalString isBootstrap "-boot"
          + lib.optionalString useNcurses "-cursesUI"
          + lib.optionalString withQt5 "-qt5UI";
  version = "3.19.7";

  src = fetchurl {
    url = "${meta.homepage}files/v${lib.versions.majorMinor version}/cmake-${version}.tar.gz";
    # compare with https://cmake.org/files/v${lib.versions.majorMinor version}/cmake-${version}-SHA-256.txt
    sha256 = "sha256-WKFfDVagr8zDzFNxI0/Oc/zGyPnb13XYmOUQuDF1WI4=";
  };

  patches = [
    # Don't search in non-Nix locations such as /usr, but do search in our libc.
    ./search-path.patch

    # Don't depend on frameworks.
    ./application-services.patch

    # Derived from https://github.com/libuv/libuv/commit/1a5d4f08238dd532c3718e210078de1186a5920d
    ./libuv-application-services.patch

  ] ++ lib.optional stdenv.isCygwin ./3.2.2-cygwin.patch;

  outputs = [ "out" ];
  setOutputFlags = false;

  setupHook = ./setup-hook.sh;

  depsBuildBuild = [ buildPackages.stdenv.cc ];

  nativeBuildInputs = [ setupHook pkg-config ];

  buildInputs = []
    ++ lib.optionals useSharedLibraries [ bzip2 curlMinimal expat libarchive xz zlib libuv rhash ]
    ++ lib.optional useOpenSSL openssl
    ++ lib.optional useNcurses ncurses
    ++ lib.optional withQt5 qtbase;

  propagatedBuildInputs = lib.optional stdenv.isDarwin ps;

  preConfigure = ''
    fixCmakeFiles .
    substituteInPlace Modules/Platform/UnixPaths.cmake \
      --subst-var-by libc_bin ${lib.getBin stdenv.cc.libc} \
      --subst-var-by libc_dev ${lib.getDev stdenv.cc.libc} \
      --subst-var-by libc_lib ${lib.getLib stdenv.cc.libc}
  ''
  # CC_FOR_BUILD and CXX_FOR_BUILD are used to bootstrap cmake
  + ''
    configureFlags="--parallel=''${NIX_BUILD_CORES:-1} CC=$CC_FOR_BUILD CXX=$CXX_FOR_BUILD $configureFlags"
  '';

  configureFlags = [
    "--docdir=share/doc/${pname}${version}"
  ] ++ (if useSharedLibraries then [ "--no-system-jsoncpp" "--system-libs" ] else [ "--no-system-libs" ]) # FIXME: cleanup
    ++ lib.optional withQt5 "--qt-gui"
    # Workaround https://gitlab.kitware.com/cmake/cmake/-/issues/20568
    ++ lib.optionals stdenv.hostPlatform.is32bit [
      "CFLAGS=-D_FILE_OFFSET_BITS=64"
      "CXXFLAGS=-D_FILE_OFFSET_BITS=64"
    ]
    ++ [
    "--"
    # We should set the proper `CMAKE_SYSTEM_NAME`.
    # http://www.cmake.org/Wiki/CMake_Cross_Compiling
    #
    # Unfortunately cmake seems to expect absolute paths for ar, ranlib, and
    # strip. Otherwise they are taken to be relative to the source root of the
    # package being built.
    "-DCMAKE_CXX_COMPILER=${stdenv.cc.targetPrefix}c++"
    "-DCMAKE_C_COMPILER=${stdenv.cc.targetPrefix}cc"
    "-DCMAKE_AR=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ar"
    "-DCMAKE_RANLIB=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}ranlib"
    "-DCMAKE_STRIP=${lib.getBin stdenv.cc.bintools.bintools}/bin/${stdenv.cc.targetPrefix}strip"

    "-DCMAKE_USE_OPENSSL=${if useOpenSSL then "ON" else "OFF"}"
    # Avoid depending on frameworks.
    "-DBUILD_CursesDialog=${if useNcurses then "ON" else "OFF"}"
  ];

  # make install attempts to use the just-built cmake
  preInstall = lib.optional (stdenv.hostPlatform != stdenv.buildPlatform) ''
    sed -i 's|bin/cmake|${buildPackages.cmakeMinimal}/bin/cmake|g' Makefile
  '';

  dontUseCmakeConfigure = true;
  enableParallelBuilding = true;

  # This isn't an autoconf configure script; triples are passed via
  # CMAKE_SYSTEM_NAME, etc.
  configurePlatforms = [ ];

  doCheck = false; # fails

  meta = with lib; {
    homepage = "https://cmake.org/";
    changelog = "https://cmake.org/cmake/help/v${lib.versions.majorMinor version}/"
      + "release/${lib.versions.majorMinor version}.html";
    description = "Cross-Platform Makefile Generator";
    longDescription = ''
      CMake is an open-source, cross-platform family of tools designed to
      build, test and package software. CMake is used to control the software
      compilation process using simple platform and compiler independent
      configuration files, and generate native makefiles and workspaces that
      can be used in the compiler environment of your choice.
    '';
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel lnl7 ];
    license = licenses.bsd3;
  };
} // (if withQt5 then { dontWrapQtApps = true; } else {})
)
