{ stdenv, fetchurl, mesa, SDL, cmake, eigen }:

let
  baseName = "soi";
  majorVersion = "0.1";
  minorVersion = "1";
  version = "${majorVersion}.${minorVersion}";
  name = "${baseName}-${version}";
in

stdenv.mkDerivation rec {
  inherit name;
  src = fetchurl {
    url = "mirror://sourceforge/project/${baseName}/${baseName}-${majorVersion}/Spheres%20of%20Influence-${version}-Source.tar.gz";
    inherit name;
    sha256 = "dfc59319d2962033709bb751c71728417888addc6c32cbec3da9679087732a81";
  };

  buildInputs = [ mesa SDL cmake eigen ];

  preConfigure = ''export EIGENDIR=${eigen}/include/eigen2'';

  meta = with stdenv.lib; {
    description = "A physics-based puzzle game";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.free;
    broken = true;
    downloadPage = "http://sourceforge.net/projects/soi/files/";
  };
}
