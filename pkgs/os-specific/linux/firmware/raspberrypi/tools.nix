{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

stdenv.mkDerivation {
  pname = "raspberrypi-tools";
  version = "2020-11-30";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "userland";
    rev = "093b30bbc2fd083d68cc3ee07e6e555c6e592d11";
    sha256 = "0n2psqyxlsic9cc5s8h65g0blblw3xws4czhpbbgjm58px3822d7";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  preConfigure = ''
    cmakeFlagsArray+=("-DVMCS_INSTALL_PREFIX=$out")
  '' + stdenv.lib.optionalString stdenv.isAarch64 ''
    cmakeFlagsArray+=("-DARM64=1")
  '';

  meta = with stdenv.lib; {
    description = "Userland tools for the Raspberry Pi board";
    homepage = "https://github.com/raspberrypi/userland";
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ dezgeg tavyc ];
  };
}
