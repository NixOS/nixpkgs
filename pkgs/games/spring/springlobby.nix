{ stdenv, fetchurl, cmake, wxGTK30, openal, pkgconfig, curl, libtorrentRasterbar
, libpng, libX11, gettext, bash, gawk, boost, libnotify, gtk, doxygen, spring
, makeWrapper, glib, minizip, alure, pcre, jsoncpp }:
stdenv.mkDerivation rec {

  name = "springlobby-${version}";
  version = "0.247";

  src = fetchurl {
    url = "http://www.springlobby.info/tarballs/springlobby-${version}.tar.bz2";
    sha256 = "0sx14k4xsyjkmphhxfn9q341lv32c53g6wl1cbdx2sknzs3qasxs";
  };

  buildInputs = [
    cmake wxGTK30 openal pkgconfig curl gettext libtorrentRasterbar pcre jsoncpp
    boost libpng libX11 libnotify gtk doxygen makeWrapper glib minizip alure
  ];

  prePatch = ''
    substituteInPlace tools/regen_config_header.sh --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace tools/test-susynclib.awk --replace "#!/usr/bin/awk" "#!${gawk}/bin/awk"
    substituteInPlace CMakeLists.txt --replace "boost_system-mt" "boost_system"
  '';

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
    maintainers = with maintainers; [ phreedom qknight iElectric ];
    platforms = platforms.linux;
  };
}
