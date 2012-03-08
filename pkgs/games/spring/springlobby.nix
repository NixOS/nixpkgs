{ stdenv, fetchurl, cmake, wxGTK, openal, pkgconfig, curl, libtorrentRasterbar
, gettext, bash, gawk, boost }:
stdenv.mkDerivation rec {

  name = "spring-lobby-${version}";
  version = "0.139";

  src = fetchurl {
    url = "http://www.springlobby.info/tarballs/springlobby-${version}.tar.bz2";
    sha256 = "0ibvv2p4c0qa933mr3hfn5lp8c6h1dycl6k6i1n2gvpa8jr598m5";
  };

  buildInputs = [ cmake wxGTK openal pkgconfig curl gettext libtorrentRasterbar boost ];

  prePatch = ''
    substituteInPlace tools/regen_config_header.sh --replace "#!/usr/bin/env bash" "#!${bash}/bin/bash"
    substituteInPlace tools/test-susynclib.awk --replace "#!/usr/bin/awk" "#!${gawk}/bin/awk"
    substituteInPlace CMakeLists.txt --replace "boost_system-mt" "boost_system"
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage = http://springlobby.info/;
    description = "A free cross-platform lobby client for the Spring RTS project.";
    license = licenses.gpl2;
    maintainers = [ maintainers.phreedom ];
    platforms = platforms.all;
  };
}