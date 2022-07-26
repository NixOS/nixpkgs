{ lib, stdenv, fetchurl, fetchpatch, cmake, wxGTK30, openal, pkg-config, curl, libtorrent-rasterbar
, libpng, libX11, gettext, boost, libnotify, gtk2, doxygen, spring
, makeWrapper, glib, minizip, alure, pcre, jsoncpp }:

stdenv.mkDerivation rec {
  pname = "springlobby";
  version = "0.270";

  src = fetchurl {
    url = "https://springlobby.springrts.com/dl/stable/springlobby-${version}.tar.bz2";
    sha256 = "1r1g2hw9ipsmsmzbhsi7bxqra1za6x7j1kw12qzl5psqyq8rqbgs";
  };

  nativeBuildInputs = [ cmake pkg-config gettext doxygen makeWrapper ];
  buildInputs = [
    wxGTK30 openal curl libtorrent-rasterbar pcre jsoncpp
    boost libpng libX11 libnotify gtk2 glib minizip alure
  ];

  patches = [
    ./revert_58b423e.patch # Allows springLobby to continue using system installed spring until #707 is fixed
    ./fix-certs.patch
    (fetchpatch {
      url = "https://github.com/springlobby/springlobby/commit/252c4cb156c1442ed9b4faec3f26265bc7c295ff.patch";
      sha256 = "sha256-Nq1F5fRPnCkZwl9KgrfuUmpIMK3hUOyZQYIKElWpmzU=";
    })
  ];

  postInstall = ''
    wrapProgram $out/bin/springlobby \
      --prefix PATH : "${spring}/bin" \
      --set SPRING_BUNDLE_DIR "${spring}/lib"
  '';

  meta = with lib; {
    homepage = "https://springlobby.info/";
    description = "Cross-platform lobby client for the Spring RTS project";
    license = licenses.gpl2;
    maintainers = with maintainers; [ qknight domenkozar ];
    platforms = platforms.linux;
  };
}
