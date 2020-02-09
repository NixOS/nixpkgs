{ stdenv, fetchurl, cmake, wxGTK30, openal, pkgconfig, curl, libtorrentRasterbar
, libpng, libX11, gettext, boost, libnotify, gtk2, doxygen, spring
, makeWrapper, glib, minizip, alure, pcre, jsoncpp }:

stdenv.mkDerivation rec {
  pname = "springlobby";
  version = "0.267";

  src = fetchurl {
    url = "http://www.springlobby.info/tarballs/springlobby-${version}.tar.bz2";
    sha256 = "0yv7j9l763iqx7hdi2pcz5jkj0068yrffb8nrav7pwg0g3s0znak";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [
    cmake wxGTK30 openal curl gettext libtorrentRasterbar pcre jsoncpp
    boost libpng libX11 libnotify gtk2 doxygen makeWrapper glib minizip alure
  ];

  patches = [ ./revert_58b423e.patch ./fix-certs.patch ]; # Allows springLobby to continue using system installed spring until #707 is fixed

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/springlobby \
      --prefix PATH : "${spring}/bin" \
      --set SPRING_BUNDLE_DIR "${spring}/lib"
  '';

  meta = with stdenv.lib; {
    homepage = https://springlobby.info/;
    repositories.git = git://github.com/springlobby/springlobby.git;
    description = "Cross-platform lobby client for the Spring RTS project";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom qknight domenkozar ];
    platforms = platforms.linux;
  };
}
