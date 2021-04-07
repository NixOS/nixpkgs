{ stdenvNoCC, lib, fetchFromGitHub, makeWrapper
, python3, binutils-unwrapped, findutils, kmod, pciutils, libraspberrypi
}:
stdenvNoCC.mkDerivation {
  pname = "raspberrypi-eeprom";
  version = "2021-03-18";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-eeprom";
    rev = "ff27ccf69403b01e337fc4ee6e7ae75244028cce";
    sha256 = "1q1vlld0xxh9zinf5g0qa6jw1dggq93br938mvrfx3nb2aviiwcj";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # Don't try to verify md5 signatures from /var/lib/dpkg and
    # fix path to the configuration.
    substituteInPlace rpi-eeprom-update \
      --replace 'IGNORE_DPKG_CHECKSUMS=$LOCAL_MODE' 'IGNORE_DPKG_CHECKSUMS=1' \
      --replace '/etc/default' '/etc'
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/rpi-eeprom

    cp rpi-eeprom-config rpi-eeprom-update $out/bin
    cp -r firmware/{beta,critical,old,stable} $out/share/rpi-eeprom
  '';

  fixupPhase = ''
    patchShebangs $out/bin
    wrapProgram $out/bin/rpi-eeprom-update \
      --set FIRMWARE_ROOT $out/share/rpi-eeprom \
      ${lib.optionalString stdenvNoCC.isAarch64 "--set VCMAILBOX ${libraspberrypi}/bin/vcmailbox"} \
      --prefix PATH : "${lib.makeBinPath ([
        binutils-unwrapped
        findutils
        kmod
        pciutils
        (placeholder "out")
      ] ++ lib.optionals stdenvNoCC.isAarch64 [
        libraspberrypi
      ])}"
  '';

  meta = with lib; {
    description = "Installation scripts and binaries for the closed sourced Raspberry Pi 4 EEPROMs";
    homepage = "https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md";
    license = with licenses; [ bsd3 unfreeRedistributableFirmware ];
    maintainers = with maintainers; [ das_j ];
  };
}
