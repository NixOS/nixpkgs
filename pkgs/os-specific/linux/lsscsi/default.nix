{ lib, stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "lsscsi-0.32";

  src = fetchurl {
    url = "http://sg.danny.cz/scsi/lsscsi-0.32.tgz";
    sha256 = "sha256-CoAOnpTcoqtwLWXXJ3eujK4Hjj100Ly+1kughJ6AKaE=";
  };

  preConfigure = ''
    substituteInPlace Makefile.in --replace /usr "$out"
  '';

  meta = with lib; {
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
