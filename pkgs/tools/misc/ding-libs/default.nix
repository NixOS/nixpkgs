{
  lib,
  stdenv,
  fetchurl,
  check,
}:

stdenv.mkDerivation rec {
  pname = "ding-libs";
  version = "0.6.1";

  src = fetchurl {
    url = "https://releases.pagure.org/SSSD/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1h97mx2jdv4caiz4r7y8rxfsq78fx0k4jjnfp7x2s7xqvqks66d3";
  };

  enableParallelBuilding = true;
  buildInputs = [ check ];

  doCheck = true;

  meta = {
    description = "'D is not GLib' utility libraries";
    homepage = "https://pagure.io/SSSD/ding-libs";
    platforms = with lib.platforms; linux;
    maintainers = with lib.maintainers; [ ];
    license = [
      lib.licenses.gpl3
      lib.licenses.lgpl3
    ];
  };
}
