{ stdenv, fetchurl, allegro }:

stdenv.mkDerivation rec {
  name = "atanks-${version}";
  version = "6.5";

  src = fetchurl {
    url = "mirror://sourceforge/project/atanks/atanks/${name}/${name}.tar.gz";
    sha256 = "0bijsbd51j4wsnmdxj54r92m7h8zqnvh9z3qqdig6zx7a8kjn61j";
  };

  buildInputs = [ allegro ];

  makeFlags = [ "PREFIX=$(out)/" "INSTALL=install" "CXX=g++" ];

  meta = with stdenv.lib; {
    description = "Atomic Tanks ballistics game";
    homepage = http://atanks.sourceforge.net/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
