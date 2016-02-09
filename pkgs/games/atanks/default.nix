{ stdenv, fetchurl, allegro }:

stdenv.mkDerivation rec {
  name = "atanks-${version}";
  version = "6.2";

  src = fetchurl {
    url = "mirror://sourceforge/project/atanks/atanks/${name}/${name}.tar.gz";
    sha256 = "1s1lb87ind0y9d6hmfaf1b9wks8q3hd6w5n9dibq75rxqmcfvlpy";
  };

  buildInputs = [ allegro ];

  patchPhase = ''
    substituteInPlace Makefile --replace /usr $out
  '';

  makeFlags = [ "PREFIX=$(out)/" "INSTALL=install" ];

  meta = with stdenv.lib; {
    description = "Atomic Tanks ballistics game";
    homepage = http://atanks.sourceforge.net/;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
