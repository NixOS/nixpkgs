{ pkgs, fetchurl, lib, stdenv, gtk3, pkg-config, intltool, alsa-lib }:

stdenv.mkDerivation {
  pname = "volumeicon";
  version = "0.5.1";

  src = fetchurl {
    url = "http://softwarebakery.com/maato/files/volumeicon/volumeicon-0.5.1.tar.gz";
    sha256 = "182xl2w8syv6ky2h2bc9imc6ap8pzh0p7rp63hh8nw0xm38c3f14";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ gtk3 intltool alsa-lib ];

  meta = with lib; {
    description = "A lightweight volume control that sits in your systray";
    homepage = "http://softwarebakery.com/maato/volumeicon.html";
    platforms = pkgs.lib.platforms.linux;
    maintainers = with maintainers; [ bobvanderlinden ];
    license = pkgs.lib.licenses.gpl3;
  };

}

