{ lib
, stdenv
, fetchFromGitHub
, gitUpdater
, cmake
, irrlichtmt
, coreutils
, libpng
, bzip2
, curl
, libogg
, jsoncpp
, libjpeg
, libGLU
, openal
, libvorbis
, sqlite
, lua5_1
, luajit
, freetype
, gettext
, doxygen
, ncurses
, graphviz
, xorg
, gmp
, libspatialindex
, leveldb
, postgresql
, hiredis
, libiconv
, zlib
, libXrandr
, libX11
, ninja
, prometheus-cpp
, OpenGL
, OpenAL ? openal
, Carbon
, Cocoa
, withTouchSupport ? false
, buildClient ? true
, buildServer ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "minetest";
  version = "5.8.0";

  src = fetchFromGitHub {
    owner = "minetest";
    repo = "minetest";
    rev = finalAttrs.version;
    hash = "sha256-Oct8nQORSH8PjYs+gHU9QrKObMfapjAlGvycj+AJnOs=";
  };

  cmakeFlags = [
    (lib.cmakeBool "BUILD_CLIENT" buildClient)
    (lib.cmakeBool "BUILD_SERVER" buildServer)
    (lib.cmakeBool "ENABLE_PROMETHEUS" buildServer)
    (lib.cmakeBool "ENABLE_TOUCH" withTouchSupport)
    # Ensure we use system libraries
    (lib.cmakeBool "ENABLE_SYSTEM_GMP" true)
    (lib.cmakeBool "ENABLE_SYSTEM_JSONCPP" true)
    # Updates are handled by nix anyway
    (lib.cmakeBool "ENABLE_UPDATE_CHECKER" false)
    # ...but make it clear that this is a nix package
    (lib.cmakeFeature "VERSION_EXTRA" "NixOS")

    # Remove when https://github.com/NixOS/nixpkgs/issues/144170 is fixed
    (lib.cmakeFeature "CMAKE_INSTALL_BINDIR" "bin")
    (lib.cmakeFeature "CMAKE_INSTALL_DATADIR" "share")
    (lib.cmakeFeature "CMAKE_INSTALL_DOCDIR" "share/doc/minetest")
    (lib.cmakeFeature "CMAKE_INSTALL_MANDIR" "share/man")
    (lib.cmakeFeature "CMAKE_INSTALL_LOCALEDIR" "share/locale")

  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
    ninja
  ];

  buildInputs = [
    irrlichtmt
    jsoncpp
    gettext
    freetype
    sqlite
    curl
    bzip2
    ncurses
    gmp
    libspatialindex
  ] ++ lib.optional (lib.meta.availableOn stdenv.hostPlatform luajit) luajit
    ++ lib.optionals stdenv.isDarwin [
    libiconv
    OpenGL
    OpenAL
    Carbon
    Cocoa
  ] ++ lib.optionals buildClient [
    libpng
    libjpeg
    libGLU
    openal
    libogg
    libvorbis
    xorg.libX11
  ] ++ lib.optionals buildServer [
    leveldb
    postgresql
    hiredis
    prometheus-cpp
  ];

  postPatch = ''
    substituteInPlace src/filesys.cpp --replace "/bin/rm" "${coreutils}/bin/rm"
  '' + lib.optionalString stdenv.isDarwin ''
    sed -i '/pagezero_size/d;/fixup_bundle/d' src/CMakeLists.txt
  '';

  postInstall = lib.optionalString stdenv.isLinux ''
    patchShebangs $out
  '' + lib.optionalString stdenv.isDarwin ''
    mkdir -p $out/Applications
    mv $out/minetest.app $out/Applications
  '';

  passthru.updateScript = gitUpdater {
    ignoredVersions = "^[^.]+$|.*-android$";
  };

  meta = with lib; {
    homepage = "https://minetest.net/";
    description = "Infinite-world block sandbox game";
    license = licenses.lgpl21Plus;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ pyrolagus fpletz fgaz ];
  };
})
