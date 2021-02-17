{ stdenvNoCC, lib, fetchFromGitHub, makeWrapper
, python3, binutils-unwrapped, findutils, kmod, pciutils, libraspberrypi
}:
stdenvNoCC.mkDerivation {
  pname = "raspberrypi-eeprom";
  version = "2021-01-11";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-eeprom";
    rev = "54cadc816ba739afd08ead6d679e647de028a65c";
    sha256 = "0zlacr4z6h40h0g47195xsbss29gaa7kf8r31h372sxsn8srlnjf";
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
    cp -r firmware/vl805 $out/bin
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
