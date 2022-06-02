{lib, stdenv, fetchurl}:

stdenv.mkDerivation rec {
  pname = "sshpass";
  version = "1.09";

  src = fetchurl {
    url = "mirror://sourceforge/sshpass/sshpass-${version}.tar.gz";
    sha256 = "sha256-cXRuXgV//psAtErEBFO/RwkZMMupa76o3Ehxfe3En7c=";
  };

  meta = with lib; {
    homepage = "https://sourceforge.net/projects/sshpass/";
    description = "Non-interactive ssh password auth";
    license = licenses.gpl2;
    maintainers = [ maintainers.madjar ];
    platforms = platforms.unix;
  };
}
