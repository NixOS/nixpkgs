{ lib
, stdenv
, fetchFromGitHub
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
}:

with lib;

let
  boolToCMake = b: if b then "ON" else "OFF";

  irrlichtmtInput = irrlichtmt.override { inherit withTouchSupport; };

  generic = { version, rev ? version, sha256, dataRev ? version, dataSha256, buildClient ? true, buildServer ? false }: let
    sources = {
      src = fetchFromGitHub {
        owner = "minetest";
        repo = "minetest";
        inherit rev sha256;
      };
      data = fetchFromGitHub {
        owner = "minetest";
        repo = "minetest_game";
        rev = dataRev;
        sha256 = dataSha256;
      };
    };
  in stdenv.mkDerivation {
    pname = "minetest";
    inherit version;

    src = sources.src;

    cmakeFlags = [
      "-G Ninja"
      "-DBUILD_CLIENT=${boolToCMake buildClient}"
      "-DBUILD_SERVER=${boolToCMake buildServer}"
      "-DENABLE_GETTEXT=1"
      "-DENABLE_SPATIAL=1"
      "-DENABLE_SYSTEM_JSONCPP=1"

      # Remove when https://github.com/NixOS/nixpkgs/issues/144170 is fixed
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_DATADIR=share"
      "-DCMAKE_INSTALL_DOCDIR=share/doc"
      "-DCMAKE_INSTALL_DOCDIR=share/doc"
      "-DCMAKE_INSTALL_MANDIR=share/man"
      "-DCMAKE_INSTALL_LOCALEDIR=share/locale"

    ] ++ optionals buildServer [
      "-DENABLE_PROMETHEUS=1"
    ] ++ optionals withTouchSupport [
      "-DENABLE_TOUCH=TRUE"
    ];

    env.NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg"; # needed since luajit-2.1.0-beta3

    nativeBuildInputs = [ cmake doxygen graphviz ninja ];

    buildInputs = [
      irrlichtmtInput jsoncpp gettext freetype sqlite curl bzip2 ncurses
      gmp libspatialindex
    ] ++ [ (if lib.meta.availableOn stdenv.hostPlatform luajit then luajit else lua5_1) ] ++ [
    ] ++ optionals stdenv.isDarwin [
      libiconv OpenGL OpenAL Carbon Cocoa
    ] ++ optionals buildClient [
      libpng libjpeg libGLU openal libogg libvorbis xorg.libX11
    ] ++ optionals buildServer [
      leveldb postgresql hiredis prometheus-cpp
    ];

    postPatch = ''
      substituteInPlace src/filesys.cpp --replace "/bin/rm" "${coreutils}/bin/rm"
    '' + lib.optionalString stdenv.isDarwin ''
      sed -i '/pagezero_size/d;/fixup_bundle/d' src/CMakeLists.txt
    '';

    postInstall = lib.optionalString stdenv.isLinux ''
      mkdir -pv $out/share/minetest/games/minetest_game/
      cp -rv ${sources.data}/* $out/share/minetest/games/minetest_game/
      patchShebangs $out
    '' + lib.optionalString stdenv.isDarwin ''
      mkdir -p $out/Applications
      mv $out/minetest.app $out/Applications
    '';

    meta = with lib; {
      homepage = "http://minetest.net/";
      description = "Infinite-world block sandbox game";
      license = licenses.lgpl21Plus;
      platforms = platforms.linux ++ platforms.darwin;
      maintainers = with maintainers; [ pyrolagus fpletz fgaz ];
    };
  };

  v5 = {
    version = "5.7.0";
    sha256 = "sha256-9AL6gTmy05yTeYfCq3EMK4gqpBWdHwvJ5Flpzj8hFAE=";
    dataSha256 = "sha256-wWgeO8513N5jQdWvZrq357fPpAU5ik06mgZraWCQawo=";
  };

  mkClient = version: generic (version // { buildClient = true; buildServer = false; });
  mkServer = version: generic (version // { buildClient = false; buildServer = true; });
in {
  minetestclient_5 = mkClient v5;
  minetestserver_5 = mkServer v5;
}
