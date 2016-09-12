{ stdenv, fetchurl, cmake, wxGTK30, openal, pkgconfig, curl, libtorrentRasterbar
, libpng, libX11, gettext, bash, gawk, boost, libnotify, gtk, doxygen, spring
, makeWrapper, glib, minizip, alure, pcre, jsoncpp }:

stdenv.mkDerivation rec {
  name = "springlobby-${version}";
  version = "0.255";

  src = fetchurl {
    url = "http://www.springlobby.info/tarballs/springlobby-${version}.tar.bz2";
    sha256 = "12iv6h1mz998lzxc2jwkza0m1yvaaq8h05k36i85xyp7g90197jw";
  };

  buildInputs = [
    cmake wxGTK30 openal pkgconfig curl gettext libtorrentRasterbar pcre jsoncpp
    boost libpng libX11 libnotify gtk doxygen makeWrapper glib minizip alure
  ];

  patches = [ ./revert_58b423e.patch ]; # Allows springLobby to continue using system installed spring until #707 is fixed

  enableParallelBuilding = true;

  postInstall = ''
    wrapProgram $out/bin/springlobby \
      --prefix PATH : "${spring}/bin" \
      --set SPRING_BUNDLE_DIR "${spring}/lib"
  '';

  meta = with stdenv.lib; {
    homepage = http://springlobby.info/;
    repositories.git = git://github.com/springlobby/springlobby.git;
    description = "Cross-platform lobby client for the Spring RTS project";
    license = licenses.gpl2;
    maintainers = with maintainers; [ phreedom qknight domenkozar ];
    platforms = platforms.linux;
  };
}
