{ stdenv
, lib
, fetchzip
, util-linux
, jq
, mtools
}:

stdenv.mkDerivation rec {
  pname = "memtest86-efi";
  version = "8.4";

  src = fetchzip {
    # TODO: We're using the previous version of memtest86 because the
    # company developing memtest86 has stopped providing a versioned download
    # link for the latest version:
    #
    # https://www.passmark.com/forum/memtest86/44494-version-8-1-distribution-file-is-not-versioned?p=44505#post44505
    #
    # However, versioned links for the previous version are available, so that
    # is what is being used.
    #
    # It does look like redistribution is okay, so if we had somewhere to host
    # binaries that we make sure to version, then we could probably keep up
    # with the latest versions released by the company.
    url = "https://www.memtest86.com/downloads/memtest86-${version}-usb.zip";
    sha256 = "sha256-jh4FKCYZbOQhRv6B7N8Hmw6RQCQvbBGaGFTMLwM1nk8=";
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
    homepage = "http://memtest86.com/";
    downloadPage = "https://www.memtest86.com/download.htm";
    description = "A tool to detect memory errors, to be run from a bootloader";
    longDescription = ''
      A UEFI app that is able to detect errors in RAM.  It can be run from a
      bootloader.  Released under a proprietary freeware license.
    '';
    # The Memtest86 License for the Free Edition states,
    # "MemTest86 Free Edition is free to download with no restrictions on usage".
    # However the source code for Memtest86 does not appear to be available.
    #
    # https://www.memtest86.com/license.htm
    license = licenses.unfreeRedistributable;
    maintainers = with maintainers; [ cdepillabout ];
    platforms = platforms.linux;
  };
}
