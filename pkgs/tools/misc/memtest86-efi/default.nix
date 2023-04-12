{ stdenv
, lib
, fetchzip
, util-linux
, jq
, mtools
}:

stdenv.mkDerivation rec {
  pname = "memtest86-efi";
  version = "9.3.1000";

  src = fetchzip {
    # We're using the Internet Archive Wayback Machine because the company developing MemTest86 has stopped providing a versioned download link for the latest version:
    # https://forums.passmark.com/memtest86/44494-version-8-1-distribution-file-is-not-versioned
    url = "https://web.archive.org/web/20211111004725/https://www.memtest86.com/downloads/memtest86-usb.zip";
    sha256 = "sha256-GJdZCUFw1uX4HcaaAy5QqDGNqHTFtrqla13wF7xCAaM=";
    stripRoot = false;
  };

  nativeBuildInputs = [
    util-linux
    jq
    mtools
  ];

  installPhase = ''
    runHook preInstall

    # memtest86 is distributed as a bootable USB image.  It contains the actual
    # memtest86 EFI app.
    #
    # The following uses sfdisk to calculate the offset of the FAT EFI System
    # Partition in the disk image, and mcopy to extract the actual EFI app from
    # the filesystem so that it can be installed directly on the hard drive.
    IMG=$src/memtest86-usb.img
    ESP_OFFSET=$(sfdisk --json $IMG | jq -r '
      # Partition type GUID identifying EFI System Partitions
      def ESP_GUID: "C12A7328-F81F-11D2-BA4B-00A0C93EC93B";
      .partitiontable |
      .sectorsize * (.partitions[] | select(.type == ESP_GUID) | .start)
    ')
    mkdir $out
    mcopy -vsi $IMG@@$ESP_OFFSET ::'/EFI/BOOT/*' $out/

    runHook postInstall
  '';

  meta = with lib; {
    homepage = "https://www.memtest86.com/";
    downloadPage = "https://www.memtest86.com/download.htm";
    changelog = "https://www.memtest86.com/whats-new.html";
    description = "A tool to detect memory errors, to be run from a bootloader";
    longDescription = ''
      A UEFI app that is able to detect errors in RAM.  It can be run from a
      bootloader.  Released under a proprietary freeware license.
    '';
    # MemTest86 Free Edition is free to download with no restrictions on usage. However, the source code is not available.
    # https://www.memtest86.com/tech_license-information.html
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ cdepillabout ];
    platforms = platforms.linux;
  };
}
