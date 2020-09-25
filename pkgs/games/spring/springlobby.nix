{ stdenv, fetchurl, cmake, wxGTK30, openal, pkgconfig, curl, libtorrentRasterbar
, libpng, libX11, gettext, boost, libnotify, gtk2, doxygen, spring
, makeWrapper, glib, minizip, alure, pcre, jsoncpp }:

stdenv.mkDerivation rec {
  pname = "springlobby";
  version = "0.270";

  src = fetchurl {
    url = "https://springlobby.springrts.com/dl/stable/springlobby-${version}.tar.bz2";
    sha256 = "1r1g2hw9ipsmsmzbhsi7bxqra1za6x7j1kw12qzl5psqyq8rqbgs";
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
    homepage = "https://springlobby.info/";
    repositories.git = "git://github.com/springlobby/springlobby.git";
    description = "Cross-platform lobby client for the Spring RTS project";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom qknight domenkozar ];
    platforms = platforms.linux;
  };
}
