{stdenv, fetchurl, gettext, openssl ? null}:

stdenv.mkDerivation rec {
  name = "wget-1.11.4";
  
  src = fetchurl {
    url = "mirror://gnu/wget/${name}.tar.bz2";
    sha256 = "1yr7w182n7lvkajvq07wnw65sw2vmxjkc3611kpc728vhvi54zwb";
  };

  buildInputs = [gettext openssl];

  meta = {
    description = "A console downloading program. Has some features for mirroring sites.";
    homepage = http://www.gnu.org/software/wget;
  };
}
