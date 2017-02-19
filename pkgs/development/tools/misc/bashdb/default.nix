{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "bashdb-4.4-0.92";

  src = fetchurl {
    url =  "mirror://sourceforge/bashdb/${name}.tar.bz2";
    sha256 = "6a8c2655e04339b954731a0cb0d9910e2878e45b2fc08fe469b93e4f2dbaaf92";
  };

  meta = { 
    description = "Bash script debugger";
    homepage = http://bashdb.sourceforge.net/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.linux;
  };
}
