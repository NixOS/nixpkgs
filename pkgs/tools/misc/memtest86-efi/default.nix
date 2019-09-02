{ lib, stdenv, fetchurl, unzip, utillinux, libguestfs-with-appliance }:

stdenv.mkDerivation rec {
  pname = "memtest86-efi";
  version = "8.0";

  src = fetchurl {
    # TODO: The latest version of memtest86 is actually 8.1, but apparently the
    # company has stopped distributing versioned binaries of memtest86:
    # https://www.passmark.com/forum/memtest86/44494-version-8-1-distribution-file-is-not-versioned?p=44505#post44505
    # However, it does look like redistribution is okay, so if we had
    # somewhere to host binaries that we make sure to version, then we could
    # probably keep up with the latest versions released by the company.
    url = "https://www.memtest86.com/downloads/memtest86-${version}-usb.zip";
    sha256 = "147mnd7fnx2wvbzscw7pkg9ljiczhz05nb0cjpmww49a0ms4yknw";
  };

  nativeBuildInputs = [ libguestfs-with-appliance unzip ];

  unpackPhase = ''
    unzip -q $src -d .
  '';

  installPhase = ''
    mkdir -p $out

    # memtest86 is distributed as a bootable USB image.  It contains the actual
    # memtest86 EFI app.
    #
    # The following command uses libguestfs to extract the actual EFI app from the
    # usb image so that it can be installed directly on the hard drive.  This creates
    # the ./BOOT/ directory with the memtest86 EFI app.
    guestfish --ro --add ./memtest86-usb.img --mount /dev/sda1:/  copy-out /EFI/BOOT .

    cp -r BOOT/* $out/
  '';

  meta = with lib; {
    homepage = http://memtest86.com/;
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
