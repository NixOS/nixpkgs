{ lib, stdenv, fetchFromGitHub, cmake, pkgconfig }:

let
  inherit (stdenv.lib) optionals;
in
stdenv.mkDerivation {
  pname = "raspberrypi-armstubs";
  version = "2020-10-08";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "tools";
    rev = "fc0e73c13865450e95edd046200e42a6e52d8256";
    sha256 = "1g6ikpjcrm5x0rk5aiwjdd8grf997qkvgamcrdxy6k9ln746h25s";
  };

  NIX_CFLAGS_COMPILE = [
    "-march=armv8-a+crc"
  ];

  preConfigure = ''
    cd armstubs
  '';

  makeFlags = [
    "CC8=${stdenv.cc.targetPrefix}cc"
    "LD8=${stdenv.cc.targetPrefix}ld"
    "OBJCOPY8=${stdenv.cc.targetPrefix}objcopy"
    "OBJDUMP8=${stdenv.cc.targetPrefix}objdump"
    "CC7=${stdenv.cc.targetPrefix}cc"
    "LD7=${stdenv.cc.targetPrefix}ld"
    "OBJCOPY7=${stdenv.cc.targetPrefix}objcopy"
    "OBJDUMP7=${stdenv.cc.targetPrefix}objdump"
  ]
  ++ optionals (stdenv.isAarch64) [ "armstub8.bin" "armstub8-gic.bin" ]
  ++ optionals (stdenv.isAarch32) [ "armstub7.bin" "armstub8-32.bin" "armstub8-32-gic.bin" ]
  ;

  installPhase = ''
    mkdir -vp $out/
    cp -v *.bin $out/
  '';

  meta = with lib; {
    description = "Firmware related ARM stubs for the Raspberry Pi";
    homepage = https://github.com/raspberrypi/tools;
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ samueldr ];
  };
}
