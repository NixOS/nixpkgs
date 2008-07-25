{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "cdrdao-1.2.2";

  src = fetchurl {
    url = mirror://sourceforge/cdrdao/cdrdao-1.2.2.tar.bz2;
    sha256 = "0f40wm08zm2809xa6kscfk10vgqa3g2vdydnr641r3kzwm0h066y";
  };

  makeFlags = "RM=rm LN=ln MV=mv";

  #buildInputs = [cmake libcap zlib bzip2];

  meta = {
    description = "A tool for recording audio or data CD-Rs in disk-at-once (DAO) mode";
    homepage = http://cdrdao.sourceforge.net/;
  };
}
