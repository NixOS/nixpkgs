{ stdenv, fetchurl, cmake, wxGTK, openal, pkgconfig, curl, libtorrentRasterbar
, gettext, bash, gawk, boost }:
stdenv.mkDerivation rec {

  name = "springlobby-${version}";
  version = "0.141";

  src = fetchurl {
    url = "http://www.springlobby.info/tarballs/springlobby-${version}.tar.bz2";
    sha256 = "37cf3aa1ed78a0ded782cc5c692301619dbb2cf4749bccbf059c51707daaf734";
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
    maintainers = [ maintainers.phreedom maintainers.qknight];
    platforms = platforms.linux;
  };
}
