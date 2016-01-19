{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ised-${version}";
  version = "2.7.0";
  src = fetchurl {
    url = "mirror://sourceforge/project/ised/${name}.tar.bz2";
    sha256 = "08wzgmyvlhfaxa0m2b6pw2mn03k1a87pzbzxm0x9z84gci9w2g4h";
  };

  meta = {
    description = "A numeric sequence editor";
    maintainers = with stdenv.lib.maintainers; [ raskin ];
    platforms = with stdenv.lib.platforms; linux;
    license = stdenv.lib.licenses.gpl3Plus;
  };
}
