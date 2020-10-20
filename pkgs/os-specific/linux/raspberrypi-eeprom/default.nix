{ stdenvNoCC, lib, fetchFromGitHub, makeWrapper
, python3, binutils-unwrapped, findutils, kmod, pciutils, raspberrypi-tools
}:
stdenvNoCC.mkDerivation {
  pname = "raspberrypi-eeprom";
  version = "unstable-2020-10-05";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-eeprom";
    rev = "718820bcebd21d4a619fa262d9b9cf3acbf110f8";
    sha256 = "1277jsiyv34dqpandva8kxy1s0y5ql344pl9gk84avzp1mqjnv4g";
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
      ${lib.optionalString stdenvNoCC.isAarch64 "--set VCMAILBOX ${raspberrypi-tools}/bin/vcmailbox"} \
      --prefix PATH : "${lib.makeBinPath ([
        binutils-unwrapped
        findutils
        kmod
        pciutils
        (placeholder "out")
      ] ++ lib.optionals stdenvNoCC.isAarch64 [
        raspberrypi-tools
      ])}"
  '';

  meta = with lib; {
    description = "Installation scripts and binaries for the closed sourced Raspberry Pi 4 EEPROMs";
    homepage = "https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md";
    license = with licenses; [ bsd3 unfreeRedistributableFirmware ];
    maintainers = with maintainers; [ das_j ];
  };
}
