{ lib, stdenv, linux }:

with lib;

assert versionAtLeast linux.version "4.6";

stdenv.mkDerivation {
  name = "gpio-utils-${linux.version}";

  inherit (linux) src makeFlags;

  preConfigure = ''
    cd tools/gpio
  '';

  separateDebugInfo = true;
  installFlags = [ "install" "DESTDIR=$(out)" "bindir=/bin" ];

  meta = {
    description = "Linux tools to inspect the gpiochip interface";
    maintainers = with stdenv.lib.maintainers; [ kwohlfahrt ];
    platforms = stdenv.lib.platforms.linux;
  };
}
