{ stdenv, fetchurl, check }:

stdenv.mkDerivation rec {
  pname = "ding-libs";
  version = "0.6.1";

  src = fetchurl {
    url = "https://fedorahosted.org/released/ding-libs/ding-libs-${version}.tar.gz";
    sha256 = "1h97mx2jdv4caiz4r7y8rxfsq78fx0k4jjnfp7x2s7xqvqks66d3";
  };

  enableParallelBuilding = true;
  buildInputs = [ check ];

  doCheck = true;

  meta = {
    description = "'D is not GLib' utility libraries";
    homepage = "https://fedorahosted.org/sssd/";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [ e-user ];
    license = [ stdenv.lib.licenses.gpl3 stdenv.lib.licenses.lgpl3 ];
  };
}
