{stdenv, fetchurl}:
stdenv.mkDerivation {
  name = "pwgen-2.05";

  src = fetchurl {
    url = mirror://sourceforge/pwgen/pwgen-2.05.tar.gz;
    sha256 = "1afxbkdl9b81760pyb972k18dmidrciy3vzcnspp3jg0aa316yn8";
  };
  meta = {
    description = "Password generator which creates passwords which can be easily memorized by a human";
    platforms = stdenv.lib.platforms.all;
  };
}
