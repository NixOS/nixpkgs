{ lib, stdenv, fetchurl, libusb1, pkg-config, ... }:

stdenv.mkDerivation rec {
  pname = "blink1";
  version = "1.98a";

  src = fetchurl {
    url = "https://github.com/todbot/blink1/archive/v${version}.tar.gz";
    sha256 = "1waci6hccv5i50v5d3z7lx4h224fbkj66ywfynnsgn46w0jm6imv";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libusb1 ];

  configurePhase = ''
    cd commandline
  '';

  installPhase = ''
    PREFIX=$out make install
  '';

  meta = {
    description = "Command line client for the blink(1) notification light";
    homepage = "https://blink1.thingm.com/";
    license = lib.licenses.cc-by-sa-30;
    maintainers = [ lib.maintainers.cransom ];
    platforms = lib.platforms.linux;
  };
}
