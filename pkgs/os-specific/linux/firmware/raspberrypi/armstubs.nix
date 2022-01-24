{ lib, stdenv, fetchFromGitHub }:

let
  inherit (lib) optionals;
in
stdenv.mkDerivation {
  pname = "raspberrypi-armstubs";
  version = "2021-07-05";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "tools";
    rev = "2e59fc67d465510179155973d2b959e50a440e47";
    sha256 = "1ysdl4qldy6ldf8cm1igxjisi14xl3s2pi6cnqzpxb38sgihb1vy";
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
