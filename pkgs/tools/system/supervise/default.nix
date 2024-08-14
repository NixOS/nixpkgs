{ lib, stdenv, fetchzip }:

stdenv.mkDerivation rec {

  pname = "supervise";
  version = "1.4.0";

  src = fetchzip {
    url = "https://github.com/catern/supervise/releases/download/v${version}/supervise-${version}.tar.gz";
    sha256 = "0jk6q2f67pfs18ah040lmsbvbrnjap7w04jjddsfn1j5bcrvs13x";
  };

  meta = with lib; {
    homepage = "https://github.com/catern/supervise";
    description = "Minimal unprivileged process supervisor making use of modern Linux features";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with lib.maintainers; [ catern ];
  };
}
