{ stdenv, mkDerivation, fetchFromGitHub, pkg-config, gcc-arm-embedded, bluez5
, readline

, hardwarePlatform ? "PM3RDV4"

, hardwarePlatformExtras ? "" }:

mkDerivation rec {
  pname = "proxmark3-rrg";
  version = "4.9237";

  src = fetchFromGitHub {
    owner = "RfidResearchGroup";
    repo = "proxmark3";
    rev = "v${version}";
    sha256 = "13xrhvrsm73rfgqpgca6a37c3jixdkxvfggmacnnx5fdfb393bfx";
  };

  nativeBuildInputs = [ pkg-config gcc-arm-embedded ];
  buildInputs = [ bluez5 readline ];

  makeFlags = [
    "PLATFORM=${hardwarePlatform}"
    "PLATFORM_EXTRAS=${hardwarePlatformExtras}"
  ];

  installPhase = ''
    install -Dt $out/bin client/proxmark3
    install -Dt $out/firmware bootrom/obj/bootrom.elf armsrc/obj/fullimage.elf
  '';

  meta = with stdenv.lib; {
    description = "Client for proxmark3, powerful general purpose RFID tool";
    homepage = "https://rfidresearchgroup.com/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ nyanotech ];
  };
}
