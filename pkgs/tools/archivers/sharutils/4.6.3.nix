{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "sharutils-4.6.3";

  src = fetchurl {
    url = "mirror://gnu/sharutils/REL-4.6.3/${name}.tar.bz2";
    sha256 = "1sirrzas8llcsd8gnh56pns39wa1f803vff1kmy5islfi1p9vqk8";
  };

  meta = {
    homepage = http://www.gnu.org/software/sharutils;
  };
}
