{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "ccd2iso-0.3";

  src = fetchurl {
    url = "mirror://sourceforge/ccd2iso/${name}.tar.gz";
    sha256 = "1z000zi7hpr2h9cabj6hzf3n6a6gd6glmm8nn36v4b8i4vzbhx7q";
  };

  meta = with stdenv.lib; {
    description = "CloneCD to ISO converter";
    homepage = "https://sourceforge.net/projects/ccd2iso/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ yegortimoshenko ];
    platforms = platforms.unix;
  };
}
