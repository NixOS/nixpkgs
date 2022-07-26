{ lib, stdenv, fetchFromGitHub }:

let
  inherit (lib) optionals;
in
stdenv.mkDerivation {
  pname = "raspberrypi-armstubs";
  version = "2021-11-01";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "tools";
    rev = "13474ee775d0c5ec8a7da4fb0a9fa84187abfc87";
    sha256 = "s/RPMIpQSznoQfchAP9gpO7I2uuTsOV0Ep4vVz7i2o4=";
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
    runHook preInstall
    mkdir -vp $out/
    cp -v *.bin $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Firmware related ARM stubs for the Raspberry Pi";
    homepage = "https://github.com/raspberrypi/tools";
    license = licenses.bsd3;
    platforms = [ "armv6l-linux" "armv7l-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ samueldr ];
  };
}
