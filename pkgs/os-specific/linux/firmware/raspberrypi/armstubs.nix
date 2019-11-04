{ stdenv, fetchFromGitHub, cmake, pkgconfig }:

let
  inherit (stdenv.lib) optionals;
in
stdenv.mkDerivation {
  pname = "raspberrypi-armstubs";
  version = "2019-09-23";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "tools";
    rev = "4a335520900ce55e251ac4f420f52bf0b2ab6b1f";
    sha256 = "02l8022g7g7sdw4ybwnb6dgkd6m0m731dzcqshngxbibsp0f9k0f";
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
    "CC=${stdenv.cc.targetPrefix}cc"
    "LD=${stdenv.cc.targetPrefix}ld"
    "OBJCOPY=${stdenv.cc.targetPrefix}objcopy"
    "OBJDUMP=${stdenv.cc.targetPrefix}objdump"
  ]
  ++ optionals (stdenv.isAarch64) [ "armstub8.bin" "armstub8-gic.bin" ]
  ++ optionals (stdenv.isAarch32) [ "armstub7.bin" "armstub8-32.bin" "armstub8-32-gic.bin" ]
  ;

  installPhase = ''
    mkdir -vp $out/
    cp -v *.bin $out/
  '';

  meta = with stdenv.lib; {
    description = "Firmware related ARM stubs for the Raspberry Pi";
    homepage = https://github.com/raspberrypi/tools;
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ samueldr ];
  };
}
