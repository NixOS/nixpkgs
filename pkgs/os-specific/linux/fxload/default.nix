{lib, stdenv, fetchgit}:

stdenv.mkDerivation rec {
  pname = "fxload";
  version = "unstable-2013-01-03";

  src = fetchgit {
    url = "https://git.code.sf.net/p/fx3load/code.git";
    rev = "31e12677df5d4ab0fdd38c8e47fe5fde82fd4b85";
    sha256 = "sha256-aHG0fBXhglPk5z8CVhuNefkQbJuicEBf1/zx2vh2F+8=";
  };

  # the source repository contains build debris
  postPatch = ''
    make clean
  '';

  preBuild = ''
    substituteInPlace Makefile --replace /usr /
    makeFlagsArray=(INSTALL=install prefix=$out)
  '';

  preInstall = ''
    mkdir -p $out/sbin
    mkdir -p $out/share/man/man8
    mkdir -p $out/share/usb
  '';

  meta = with lib; {
    homepage = "http://linux-hotplug.sourceforge.net/?selected=usb";
    description = "Tool to upload firmware to Cypress EZ-USB microcontrollers";
    license = licenses.gpl2;
    platforms = platforms.linux;
    maintainers = with maintainers; [ spacekitteh ];
  };
}
