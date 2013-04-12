{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "silc-server-1.1.18";

  src = fetchurl {
    url = "http://silcnet.org/download/server/sources/silc-server-1.1.18.tar.bz2";
    sha256 = "0nr0hrwr4kbi611qazmrify7a27nzxb5n7d97f5i9cw3avxlw38s";
  };

  meta = {
    homepage = http://silcnet.org/;
    description = "Secure Internet Live Conferencing server";
    license = "GPLv2";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
