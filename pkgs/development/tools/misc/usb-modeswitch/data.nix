{
  lib,
  stdenv,
  fetchurl,
  tcl,
  usb-modeswitch,
}:

stdenv.mkDerivation rec {
  pname = "usb-modeswitch-data";
  version = "20191128";

  src = fetchurl {
    url = "http://www.draisberghof.de/usb_modeswitch/${pname}-${version}.tar.bz2";
    sha256 = "1ygahl3r26r38ai8yyblq9nhf3v5i6n6r6672p5wf88wg5h9n0rz";
  };

  makeFlags = [
    "PREFIX=$(out)"
    "DESTDIR=$(out)"
  ];

  prePatch = ''
    sed -i 's@usb_modeswitch@${usb-modeswitch}/lib/udev/usb_modeswitch@g' 40-usb_modeswitch.rules
  '';

  # we add tcl here so we can patch in support for new devices by dropping config into
  # the usb_modeswitch.d directory
  nativeBuildInputs = [ tcl ];

  meta = with lib; {
    description = "Device database and the rules file for 'multi-mode' USB devices";
    inherit (usb-modeswitch.meta) license maintainers platforms;
  };
}
