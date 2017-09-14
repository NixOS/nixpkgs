{ stdenv, fetchurl, tcl, usb-modeswitch }:

stdenv.mkDerivation rec {
  name = "usb-modeswitch-data-${version}";
  version = "20170205";

  src = fetchurl {
    url    = "http://www.draisberghof.de/usb_modeswitch/${name}.tar.bz2";
    sha256 = "1l9q4xk02zd0l50bqhyk906wbcs26ji7259q0f7qv3cj52fzvp72";
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
