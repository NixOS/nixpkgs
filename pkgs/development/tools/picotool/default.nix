{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libusb1, pico-sdk }:

stdenv.mkDerivation rec {
  pname = "picotool";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = version;
    sha256 = "1k5j742sj91akdrgnd3wa5csqb638dgaz0c09zsr22fcqz0qhzig";
  };

  buildInputs = [ libusb1 pico-sdk ];
  nativeBuildInputs = [ cmake pkg-config ];
  cmakeFlags = [ "-DPICO_SDK_PATH=${pico-sdk}/lib/pico-sdk" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 ./picotool -t $out/bin
    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://github.com/raspberrypi/picotool";
    description = "Tool for interacting with a RP2040 device in BOOTSEL mode, or with a RP2040 binary";
    license = licenses.bsd3;
    maintainers = with maintainers; [ musfay ];
    platforms = platforms.unix;
  };
}
