{ stdenv, fetchurl, pam }:

stdenv.mkDerivation rec {
  name = "oath-toolkit-2.0.2";

  src = fetchurl {
    url = "http://download.savannah.gnu.org/releases/oath-toolkit/${name}.tar.gz";
    sha256 = "0i2rf5j83kb8h3sd9lsm0a46zq805kzagvccc4rk7879lg1fnl99";
  };

  buildInputs = [ pam ];

  meta = {
    homepage = http://www.nongnu.org/oath-toolkit/;
    description = "Components for building one-time password authentication systems";
    platforms = stdenv.lib.platforms.linux;
  };
}
