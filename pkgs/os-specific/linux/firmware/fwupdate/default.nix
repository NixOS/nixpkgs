{ stdenv, fetchurl, gnu-efi, efivar, libsmbios, popt, pkgconfig
, gettext }:
let version = "8"; in
  stdenv.mkDerivation
    { name = "fwupdate-${version}";
      src = fetchurl
        { url = "https://github.com/rhinstaller/fwupdate/releases/download/${version}/fwupdate-${version}.tar.bz2";
          sha256 = "10q8k1kghvbcb5fwcl2smzp8vqdfzimx9dkk0c3hz39py1phy4n8";
        };
      makeFlags =
        [ "EFIDIR=nixos"
          "LIBDIR=$(out)/lib"
          "GNUEFIDIR=${gnu-efi}/lib"
          "TARGETDIR=$(out)/boot/efi/nixos/"
          "prefix=$(out)/"
        ];
      buildInputs = [ gnu-efi libsmbios popt pkgconfig gettext ];
      propagatedBuildInputs = [ efivar ];
      # TODO: Just apply the disable to the efi subdir
      hardeningDisable = "all";
      patchPhase = ''
        sed -i 's|/usr/include/smbios_c/token.h|smbios_c/token.h|' \
          linux/libfwup.c
        sed -i 's|/usr/share|$(prefix)share|' linux/Makefile
        sed -i "s|/usr/include|$out/include|" linux/fwup.pc.in
      '';
      configurePhase = ''
        arch=$(cc -dumpmachine | cut -f1 -d- | sed 's,i[3456789]86,ia32,' )
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${gnu-efi}/include/efi -I${efivar}/include/efivar -I${gnu-efi}/include/efi/$arch"
      '';
      meta =
        { license = [ stdenv.lib.licenses.gpl2 ];
          platforms = stdenv.lib.platforms.linux;
        };
    }
