{ lib, stdenv, linux }:

stdenv.mkDerivation {
  pname = "gpio-utils";
  version = linux.version;

  inherit (linux) src makeFlags;

  preConfigure = ''
    cd tools/gpio
  '';

  separateDebugInfo = true;
  installFlags = [ "install" "DESTDIR=$(out)" "bindir=/bin" ];

  meta = with lib; {
    description = "Linux tools to inspect the gpiochip interface";
    maintainers = with maintainers; [ kwohlfahrt ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
  };
}
