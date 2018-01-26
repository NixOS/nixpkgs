{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bashdb-4.4-0.94";

  src = fetchurl {
    url =  "mirror://sourceforge/bashdb/${name}.tar.bz2";
    sha256 = "01n0dml866sacls7q8h1c6mm4nc47lq3vrar9idmkajky71aycar";
  };

  meta = {
    description = "Bash script debugger";
    homepage = http://bashdb.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
