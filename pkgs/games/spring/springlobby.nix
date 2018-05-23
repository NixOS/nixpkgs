{ stdenv, fetchurl, cmake, wxGTK30, openal, pkgconfig, curl, libtorrentRasterbar
, libpng, libX11, gettext, bash, gawk, boost, libnotify, gtk2, doxygen
, makeWrapper, glib, minizip, alure, pcre, jsoncpp, buildFHSUserEnv, SDL2
, libGLU, curlFull }:

let
  springlobby = stdenv.mkDerivation rec {
    name = "springlobby-${version}";
    version = "0.264";

    src = fetchurl {
      url = "http://www.springlobby.info/tarballs/springlobby-${version}.tar.bz2";
      sha256 = "5d3c98169a4c9106dd6f112823cfa0e44846cedca3920050151472bfb75561c4";
    };

    nativeBuildInputs = [
      cmake
      doxygen
      makeWrapper
      pkgconfig
    ];
    
    buildInputs = [
      alure
      boost
      curl
      doxygen
      gettext
      glib
      gtk2
      jsoncpp
      libX11
      libnotify
      libpng
      libtorrentRasterbar
      minizip
      openal
      pcre
      wxGTK30
    ];

    patches = [
      # Allows springLobby to continue using system installed spring until
      # https://github.com/springlobby/springlobby/issues/707 is fixed:
      ./revert_58b423e.patch
    ];

    enableParallelBuilding = true;

    postInstall = "wrapProgram $out/bin/springlobby";
    
    meta = with stdenv.lib; {
      description = "Cross-platform lobby client for the Spring RTS project";
      homepage = http://springlobby.info/;
      license = licenses.gpl2Plus;
      maintainers = with maintainers; [ phreedom qknight domenkozar ];
      platforms = platforms.linux;
    };
  };
in

buildFHSUserEnv {
  name = "springlobby";
  targetPkgs = _: [ curlFull libGLU openal SDL2 springlobby ];
  runScript = "springlobby";
  inherit (springlobby) meta;
}
