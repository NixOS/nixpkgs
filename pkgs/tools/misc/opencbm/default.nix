{ lib
, stdenv
, fetchFromGitHub
, cc65
, ncurses
, pkg-config
, libusb1
}:

stdenv.mkDerivation rec {
  pname = "opencbm";
  version = "0.4.99.103";

  src = fetchFromGitHub {
    owner = "OpenCBM";
    repo = "OpenCBM";
    rev = "v${version}";
    sha256 = "06844yfgcbbwrp3iz5k8zd1zjawzbpvl131lgmkwz6d542c2k4k9";
  };

  makefile = "LINUX/Makefile";
  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "ETCDIR=${placeholder "out"}/etc"
    "UDEVRULESDIR=${placeholder "out"}/etc/udev/rules.d/"
    "LDCONFIG=true"
  ];
  installTargets = "install-all";

  nativeBuildInputs = [
    cc65
    pkg-config
  ];
  buildInputs = [
    libusb1
    ncurses
  ];

  meta = with lib; {
    description = "Kernel driver and development library to control serial CBM devices";
    longDescription = ''
      Win 7/8/10, and Linux/i386/AMD64 kernel driver and development library to
      control serial CBM devices, such as the Commodore 1541 disk drive,
      connected to the PC's parallel port via a XM1541 or XA1541 cable. Fast
      disk copier included. Successor of cbm4linux. Also supports the XU1541
      and the XUM1541 devices (a.k.a. "ZoomFloppy").
    '';
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = [ maintainers.sander ];
  };
}
