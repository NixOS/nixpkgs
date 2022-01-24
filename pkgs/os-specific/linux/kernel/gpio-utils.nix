{ lib, stdenv, linux }:

with lib;

assert versionAtLeast linux.version "4.6";

stdenv.mkDerivation {
  pname = "gpio-utils";
  version = linux.version;

  inherit (linux) src makeFlags;

  preConfigure = ''
    cd tools/gpio
  '';

  separateDebugInfo = true;
  installFlags = [ "install" "DESTDIR=$(out)" "bindir=/bin" ];

  meta = {
    description = "Linux tools to inspect the gpiochip interface";
    maintainers = with maintainers; [ kwohlfahrt ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
}
