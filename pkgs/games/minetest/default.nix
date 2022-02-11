{ lib, stdenv, fetchFromGitHub, cmake, irrlicht, libpng, bzip2, curl, libogg, jsoncpp
, libjpeg, libXxf86vm, libGLU, libGL, openal, libvorbis, sqlite, luajit
, freetype, gettext, doxygen, ncurses, graphviz, xorg, gmp, libspatialindex
, leveldb, postgresql, hiredis, libiconv, zlib, libXrandr, libX11, ninja, prometheus-cpp
, OpenGL, OpenAL ? openal, Carbon, Cocoa
}:

with lib;

let
  boolToCMake = b: if b then "ON" else "OFF";

  irrlichtMt = stdenv.mkDerivation rec {
    pname = "irrlichtMt";
    version = "1.9.0mt4";
    src = fetchFromGitHub {
      owner = "minetest";
      repo = "irrlicht";
      rev = version;
      sha256 = "sha256-YlXn9LrfGkjdb8+zQGDgrInolUYj9nVSF2AXWFpEEkw=";
    };
    nativeBuildInputs = [ cmake ];
    buildInputs = [ zlib libjpeg libpng libGLU libGL libXrandr libX11 libXxf86vm ];
    outputs = [ "out" "dev" ];
    meta = irrlicht.meta;
  };

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
      "-DIRRLICHT_INCLUDE_DIR=${irrlichtMt.dev}/include/irrlicht"

      # Remove when https://github.com/NixOS/nixpkgs/issues/144170 is fixed
      "-DCMAKE_INSTALL_BINDIR=bin"
      "-DCMAKE_INSTALL_DATADIR=share"
      "-DCMAKE_INSTALL_DOCDIR=share/doc"
      "-DCMAKE_INSTALL_DOCDIR=share/doc"
      "-DCMAKE_INSTALL_MANDIR=share/man"
      "-DCMAKE_INSTALL_LOCALEDIR=share/locale"

    ] ++ optionals buildClient [
      "-DOpenGL_GL_PREFERENCE=GLVND"
    ] ++ optionals buildServer [
      "-DENABLE_PROMETHEUS=1"
    ];

    NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg"; # needed since luajit-2.1.0-beta3

    nativeBuildInputs = [ cmake doxygen graphviz ninja ];

    buildInputs = [
      irrlichtMt luajit jsoncpp gettext freetype sqlite curl bzip2 ncurses
      gmp libspatialindex
    ] ++ optionals stdenv.isDarwin [
      libiconv OpenGL OpenAL Carbon Cocoa
    ] ++ optionals buildClient [
      libpng libjpeg libGLU libGL openal libogg libvorbis xorg.libX11 libXxf86vm
    ] ++ optionals buildServer [
      leveldb postgresql hiredis prometheus-cpp
    ];

    postInstall = ''
      mkdir -pv $out/share/minetest/games/minetest_game/
      cp -rv ${sources.data}/* $out/share/minetest/games/minetest_game/
    '';

    meta = with lib; {
      homepage = "http://minetest.net/";
      description = "Infinite-world block sandbox game";
      license = licenses.lgpl21Plus;
      platforms = platforms.linux ++ platforms.darwin;
      maintainers = with maintainers; [ pyrolagus fpletz ];
      # never built on Hydra
      # https://hydra.nixos.org/job/nixpkgs/trunk/minetestclient_4.x86_64-darwin
      # https://hydra.nixos.org/job/nixpkgs/trunk/minetestserver_4.x86_64-darwin
      broken = (lib.versionOlder version "5.0.0") && stdenv.isDarwin;
    };
  };

  v5 = {
    version = "5.5.0";
    sha256 = "sha256-V+ggqvZibSQrJbrtNCEkmRYHhgSKTQsdBh3c8+t6WeA=";
    dataSha256 = "sha256-6ZS3EET3nm09eL0czCGadwzon35/EBfAg2KjPX3ZP/0=";
  };

in {
  minetestclient_5 = generic (v5 // { buildClient = true; buildServer = false; });
  minetestserver_5 = generic (v5 // { buildClient = false; buildServer = true; });
}
