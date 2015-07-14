{ stdenv, fetchurl, mesa, SDL, cmake, eigen }:

let
  baseName = "soi";
  fileName = "Spheres%20of%20Influence";
  majorVersion = "0.1";
  minorVersion = "1";
  version = "${majorVersion}.${minorVersion}";
  name = "${baseName}-${version}";
  project = "${baseName}";
in

stdenv.mkDerivation rec {
  src = fetchurl {
    url = "mirror://sourceforge/project/${project}/${baseName}-${majorVersion}/${fileName}-${version}-Source.tar.gz";
    sha256 = "dfc59319d2962033709bb751c71728417888addc6c32cbec3da9679087732a81";
  };

  buildInputs = [ mesa SDL cmake eigen ];

  preConfigure = ''export EIGENDIR=${eigen}/include/eigen2'';

  meta = with stdenv.lib; {
    description = "A physics-based puzzle game";
    maintainers = with maintainers;
    [
      raskin
    ];
    platforms = platforms.linux;
    license = licenses.free;
    broken = true;
   downloadPage = "http://sourceforge.net/projects/soi/files/";
  };
}
