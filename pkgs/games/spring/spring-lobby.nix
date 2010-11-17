{ stdenv, fetchurl, cmake, wxGTK, openal, pkgconfig, curl, libtorrentRasterbar
, gettext, bash, gawk, boost }:
stdenv.mkDerivation rec {

  name = "spring-lobby-${version}";
  version = "0.116";

  src = fetchurl {
    url = "http://www.springlobby.info/tarballs/springlobby-${version}.tar.bz2";
    sha256 = "04gb2dc2xc0lj2d14jzz330kn5faffdz3xph9bg2m68b28fv0xsk";
  };

  buildInputs = [ cmake wxGTK openal pkgconfig curl gettext libtorrentRasterbar boost ];

  prePatch = ''
    substituteInPlace tools/regen_config_header.sh --replace "#!/bin/bash" "#!${bash}/bin/bash"
    substituteInPlace tools/test-susynclib.awk --replace "#!/usr/bin/awk" "#!${gawk}/bin/awk"
    substituteInPlace CMakeLists.txt --replace "boost_system-mt" "boost_system"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://springlobby.info/;
    description = "A free cross-platform lobby client for the Spring RTS project.";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.linux;
  };
}