{ stdenv, fetchFromGitHub, cmake, irrlicht, libpng, bzip2, curl, libogg, jsoncpp
, libjpeg, libXxf86vm, libGLU_combined, openal, libvorbis, sqlite, luajit
, freetype, gettext, doxygen, ncurses, graphviz, xorg
, leveldb, postgresql, hiredis
}:

with stdenv.lib;

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

    NIX_CFLAGS_COMPILE = [ "-DluaL_reg=luaL_Reg" ]; # needed since luajit-2.1.0-beta3

    nativeBuildInputs = [ cmake doxygen graphviz ];

    buildInputs = [
      irrlicht luajit jsoncpp gettext freetype sqlite curl bzip2 ncurses
    ] ++ optionals buildClient [
      libpng libjpeg libGLU_combined openal libogg libvorbis xorg.libX11 libXxf86vm
    ] ++ optional buildServer [
      leveldb postgresql hiredis
    ];

    postInstall = ''
      mkdir -pv $out/share/minetest/games/minetest_game/
      cp -rv ${sources.data}/* $out/share/minetest/games/minetest_game/
    '';

    meta = with stdenv.lib; {
      homepage = http://minetest.net/;
      description = "Infinite-world block sandbox game";
      license = licenses.lgpl21Plus;
      platforms = platforms.linux;
      maintainers = with maintainers; [ pyrolagus fpletz ];
    };
  };

  v4 = {
    version = "0.4.17.1";
    sha256 = "19sfblgh9mchkgw32n7gdvm7a8a9jxsl9cdlgmxn9bk9m939a2sg";
    dataSha256 = "1g8iw2pya32ifljbdx6z6rpcinmzm81i9minhi2bi1d500ailn7s";
  };

  v5 = {
    version = "5.0.1";
    sha256 = "11i8fqjpdggqfdlx440k5758zy0nbf9phxan9r63mavc7mph88ay";
    dataSha256 = "1hw3n7qqpasq6bivxhq01kr0d58w0gp46s0baxixp1fakd79p8a7";
  };

in {
  minetestclient_4 = generic (v4 // { buildClient = true; buildServer = false; });
  minetestserver_4 = generic (v4 // { buildClient = false; buildServer = true; });

  minetestclient_5 = generic (v5 // { buildClient = true; buildServer = false; });
  minetestserver_5 = generic (v5 // { buildClient = false; buildServer = true; });
}
