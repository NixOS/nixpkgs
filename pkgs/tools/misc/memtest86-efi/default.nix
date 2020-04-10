{ fetchzip, lib, p7zip, stdenv }:

stdenv.mkDerivation rec {
  pname = "memtest86-efi";
  version = "8.3";

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
    sha256 = "0aldz7rvnfnzb4h447q10k9c9p5ghwzdyn7f6g5lrxiv5vxf3x96";
    stripRoot = false;
  };

  nativeBuildInputs = [ p7zip ];

  installPhase = ''
    mkdir -p $out

    # memtest86 is distributed as a bootable USB image.  It contains the actual
    # memtest86 EFI app.
    #
    # The following command uses p7zip to extract the actual EFI app from the
    # usb image so that it can be installed directly on the hard drive.
    7z x -o$TEMP/temp-efi-dirs $src/memtest86-usb.img
    7z x -o$TEMP/memtest86-files $TEMP/temp-efi-dirs/EFI\ System\ Partition.img
    cp -r $TEMP/memtest86-files/EFI/BOOT/* $out/
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
