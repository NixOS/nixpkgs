{ stdenv, fetchurl, tcl, usb-modeswitch }:

stdenv.mkDerivation rec {
  pname = "usb-modeswitch-data";
  version = "20170806";

  src = fetchurl {
    url    = "http://www.draisberghof.de/usb_modeswitch/${pname}-${version}.tar.bz2";
    sha256 = "0b1wari3aza6qjggqd0hk2zsh93k1q8scgmwh6f8wr0flpr3whff";
  };

  inherit (usb-modeswitch) makeFlags;

  prePatch = ''
    sed -i 's@usb_modeswitch@${usb-modeswitch}/bin/usb_modeswitch@g' 40-usb_modeswitch.rules
  '';

  # we add tcl here so we can patch in support for new devices by dropping config into
  # the usb_modeswitch.d directory
  nativeBuildInputs = [ tcl ];

  meta = with stdenv.lib; {
    description = "Device database and the rules file for 'multi-mode' USB devices";
    inherit (usb-modeswitch.meta) license maintainers platforms;
  };
}
