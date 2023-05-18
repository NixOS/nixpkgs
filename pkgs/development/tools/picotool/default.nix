{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libusb1, pico-sdk }:

stdenv.mkDerivation rec {
  pname = "picotool";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = version;
    sha256 = "sha256-KP5Cq6pYKQI5dV6S4lLapu9EcwAgLgYpK0qreNDZink=";
  };

  buildInputs = [ libusb1 pico-sdk ];
  nativeBuildInputs = [ cmake pkg-config ];
  cmakeFlags = [ "-DPICO_SDK_PATH=${pico-sdk}/lib/pico-sdk" ];

  meta = with lib; {
    homepage = "https://github.com/raspberrypi/picotool";
    description = "Tool for interacting with a RP2040 device in BOOTSEL mode, or with a RP2040 binary";
    license = licenses.bsd3;
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.unix;
  };
}
