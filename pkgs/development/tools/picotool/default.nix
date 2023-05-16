{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libusb1, pico-sdk }:

stdenv.mkDerivation rec {
  pname = "picotool";
<<<<<<< HEAD
  version = "1.1.2";
=======
  version = "1.1.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-OcQJeiva6X2rUyh1rJ+w4O2dWxaR7MwMfbHlnWuBVb8=";
=======
    sha256 = "sha256-KP5Cq6pYKQI5dV6S4lLapu9EcwAgLgYpK0qreNDZink=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
