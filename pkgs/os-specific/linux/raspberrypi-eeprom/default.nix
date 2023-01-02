{ stdenvNoCC, lib, fetchFromGitHub, makeWrapper
, python3, binutils-unwrapped, findutils, kmod, pciutils, libraspberrypi
}:
stdenvNoCC.mkDerivation rec {
  pname = "raspberrypi-eeprom";
  version = "2022.12.07-138a1";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-eeprom";
    rev = "v${version}";
    hash = "sha256-/Q9zj/Hn/8S7bF1CN6ZCg705VYU+QUagNr4RNgZl+oA=";
  };

  buildInputs = [ python3 ];
  nativeBuildInputs = [ makeWrapper ];

  postPatch = ''
    # Don't try to verify md5 signatures from /var/lib/dpkg and
    # fix path to the configuration.
    substituteInPlace rpi-eeprom-update \
      --replace 'IGNORE_DPKG_CHECKSUMS=''${LOCAL_MODE}' 'IGNORE_DPKG_CHECKSUMS=1' \
      --replace '/etc/default' '/etc'
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/rpi-eeprom

    cp rpi-eeprom-config rpi-eeprom-update rpi-eeprom-digest $out/bin
    cp -r firmware/{beta,critical,old,stable} $out/share/rpi-eeprom
    cp -P firmware/default firmware/latest $out/share/rpi-eeprom
  '';

  fixupPhase = ''
    patchShebangs $out/bin
    for i in rpi-eeprom-update rpi-eeprom-config; do
      wrapProgram $out/bin/$i \
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
    done
  '';

  meta = with lib; {
    description = "Installation scripts and binaries for the closed sourced Raspberry Pi 4 EEPROMs";
    homepage = "https://www.raspberrypi.org/documentation/hardware/raspberrypi/booteeprom.md";
    license = with licenses; [ bsd3 unfreeRedistributableFirmware ];
    maintainers = with maintainers; [ das_j ];
  };
}
