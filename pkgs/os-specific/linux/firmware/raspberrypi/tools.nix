{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation rec {
  name = "raspberrypi-tools-${version}";
  version = "2018-02-05";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "userland";
    rev = "a343dcad1dae4e93f4bfb99496697e207f91027e";
    sha256 = "1z4qrwjb7x3a45mx978q8vyhnx068sgzhymm4z0ayhckji4ngal1";
  };

  patches = [ ./tools-dont-install-sysv-init-scripts.patch ];

  nativeBuildInputs = [ cmake pkgconfig ];

  preConfigure = ''
    cmakeFlagsArray+=("-DVMCS_INSTALL_PREFIX=$out")
  '' + stdenv.lib.optionalString stdenv.isAarch64 ''
    cmakeFlagsArray+=("-DARM64=1")
  '';

  meta = with stdenv.lib; {
    description = "Userland tools for the Raspberry Pi board";
    homepage = https://github.com/raspberrypi/userland;
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ dezgeg viric tavyc ];
  };
}
