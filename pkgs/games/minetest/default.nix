{ lib, stdenv, fetchFromGitHub, cmake, irrlicht, libpng, bzip2, curl, libogg, jsoncpp
, libjpeg, libXxf86vm, libGLU, libGL, openal, libvorbis, sqlite, luajit
, freetype, gettext, doxygen, ncurses, graphviz, xorg, gmp, libspatialindex
, leveldb, postgresql, hiredis, libiconv, OpenGL, OpenAL ? openal, Carbon, Cocoa
}:

with lib;

let
  boolToCMake = b: if b then "ON" else "OFF";

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
      "-DBUILD_CLIENT=${boolToCMake buildClient}"
      "-DBUILD_SERVER=${boolToCMake buildServer}"
      "-DENABLE_FREETYPE=1"
      "-DENABLE_GETTEXT=1"
      "-DENABLE_SYSTEM_JSONCPP=1"
      "-DIRRLICHT_INCLUDE_DIR=${irrlicht}/include/irrlicht"
    ] ++ optionals buildClient [
      "-DOpenGL_GL_PREFERENCE=GLVND"
    ];

    NIX_CFLAGS_COMPILE = "-DluaL_reg=luaL_Reg"; # needed since luajit-2.1.0-beta3

    nativeBuildInputs = [ cmake doxygen graphviz ];

    buildInputs = [
      irrlicht luajit jsoncpp gettext freetype sqlite curl bzip2 ncurses
      gmp libspatialindex
    ] ++ optionals stdenv.isDarwin [
      libiconv OpenGL OpenAL Carbon Cocoa
    ] ++ optionals buildClient [
      libpng libjpeg libGLU libGL openal libogg libvorbis xorg.libX11 libXxf86vm
    ] ++ optionals buildServer [
      leveldb postgresql hiredis
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

  v4 = {
    version = "0.4.17.1";
    sha256 = "19sfblgh9mchkgw32n7gdvm7a8a9jxsl9cdlgmxn9bk9m939a2sg";
    dataSha256 = "1g8iw2pya32ifljbdx6z6rpcinmzm81i9minhi2bi1d500ailn7s";
  };

  v5 = {
    version = "5.4.1";
    sha256 = "062ilb7s377q3hwfhl8q06vvcw2raydz5ljzlzwy2dmyzmdcndb8";
    dataSha256 = "0i45lbnikvgj9kxdp0yphpjjwjcgp4ibn49xkj78j5ic1s9n8jd4";
  };

in {
  minetestclient_4 = generic (v4 // { buildClient = true; buildServer = false; });
  minetestserver_4 = generic (v4 // { buildClient = false; buildServer = true; });

  minetestclient_5 = generic (v5 // { buildClient = true; buildServer = false; });
  minetestserver_5 = generic (v5 // { buildClient = false; buildServer = true; });
}
