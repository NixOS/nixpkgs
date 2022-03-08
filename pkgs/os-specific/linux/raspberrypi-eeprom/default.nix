{ stdenvNoCC, lib, fetchFromGitHub, makeWrapper
, python3, binutils-unwrapped, findutils, kmod, pciutils, libraspberrypi
}:
stdenvNoCC.mkDerivation rec {
  pname = "raspberrypi-eeprom";
  version = "2021.12.02";
  # From 3fdf703f3f7bbe57eacceada3b558031229a34b0 Mon Sep 17 00:00:00 2001
  # From: Peter Harper <peter.harper@raspberrypi.com>
  # Date: Mon, 13 Dec 2021 11:56:11 +0000
  # Subject: [PATCH] 2021-12-02: Promote the 2021-12-02 beta release to LATEST/STABLE
  commit = "3fdf703f3f7bbe57eacceada3b558031229a34b0";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "rpi-eeprom";
    rev = commit;
    sha256 = "sha256-JTL2ziOkT0tnOrOS08ttNtxj3qegsacP73xZBVur7xM=";
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
