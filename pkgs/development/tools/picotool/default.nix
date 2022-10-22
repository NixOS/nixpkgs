{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libusb1, pico-sdk }:

stdenv.mkDerivation rec {
  pname = "picotool";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = pname;
    rev = version;
    sha256 = "sha256-YjDHoRcDoezyli42bJ0bnfjdNNY8l6ZilrxhOudqvwE=";
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
    maintainers = with maintainers; [ muscaln ];
    platforms = platforms.unix;
  };
}
