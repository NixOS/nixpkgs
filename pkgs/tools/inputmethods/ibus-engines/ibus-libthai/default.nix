{ lib, stdenv, fetchurl, makeWrapper, pkg-config, ibus, gtk3, libthai }:

stdenv.mkDerivation rec {
  pname = "ibus-libthai";
  version = "0.1.4";

  src = fetchurl {
    url = "https://linux.thai.net/pub/ThaiLinux/software/libthai/ibus-libthai-${version}.tar.xz";
    sha256 = "0iam7308rxkx2xwaabc5wyj7vrxgd4cr95pvwrkm8fr9gh2xnwgv";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ gtk3 ibus libthai ];

  meta = with lib; {
    isIbusEngine = true;
    homepage = "https://linux.thai.net/projects/ibus-libthai";
    description = "Thai input method engine for IBus";
    license = licenses.lgpl21Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
