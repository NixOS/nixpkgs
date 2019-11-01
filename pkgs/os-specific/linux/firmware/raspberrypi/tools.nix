{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation {
  pname = "raspberrypi-tools";
  version = "2018-10-03";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "userland";
    rev = "de4a7f2e3c391e2d3bc76af31864270e7802d9ac";
    sha256 = "0w96xa98ngdk9m6wv185w8waa7wm2hkn2bhxz52zd477hchzrxlg";
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
    maintainers = with maintainers; [ dezgeg tavyc ];
  };
}
