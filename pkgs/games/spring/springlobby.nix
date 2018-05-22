{ stdenv, fetchurl, cmake, wxGTK30, openal, pkgconfig, curl, libtorrentRasterbar
, libpng, libX11, gettext, bash, gawk, boost, libnotify, gtk2, doxygen
, makeWrapper, glib, minizip, alure, pcre, jsoncpp, buildFHSUserEnv, SDL2, libGLU, curlFull }:
let
  version = "0.264";

  meta = with stdenv.lib; {
    homepage = http://springlobby.info/;
    repositories.git = git://github.com/springlobby/springlobby.git;
    description = "Cross-platform lobby client for the Spring RTS project";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom qknight domenkozar ];
    platforms = platforms.linux;
  };
  springlobby = stdenv.mkDerivation rec {
    name = "springlobby-${version}";
    inherit version;
    inherit meta;

    src = fetchurl {
      url = "http://www.springlobby.info/tarballs/springlobby-${version}.tar.bz2";
      sha256 = "5d3c98169a4c9106dd6f112823cfa0e44846cedca3920050151472bfb75561c4";
    };

    nativeBuildInputs = [ pkgconfig ];
    buildInputs = [
      cmake wxGTK30 openal curl gettext libtorrentRasterbar pcre jsoncpp
      boost libpng libX11 libnotify gtk2 doxygen makeWrapper glib minizip alure
    ];

    patches = [ ./revert_58b423e.patch ]; # Allows springLobby to continue using system installed spring until #707 is fixed

    enableParallelBuilding = true;

    postInstall = ''
      wrapProgram $out/bin/springlobby
    '';

  };
in
  buildFHSUserEnv {
    name = "springlobby";
    targetPkgs = pkgs: [ springlobby SDL2 libGLU openal curlFull ];
    runScript = "springlobby";
    inherit meta;
  }
