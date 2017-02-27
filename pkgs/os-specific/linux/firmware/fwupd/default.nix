{ stdenv, fetchurl, gtk_doc, pkgconfig, gobjectIntrospection, intltool
, libgudev, polkit, gcab, appstream-glib, gusb, sqlite, libarchive
, libsoup, docbook2x, gpgme, libxslt, libelf, libsmbios, efivar
, fwupdate, libgpgerror, libyaml, valgrind
}:
let version = "0.8.1"; in
  stdenv.mkDerivation
    { name = "fwupd-${version}";
      src = fetchurl
        { url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
          sha256 = "0sq0aay5d6b0vgr7j7y4i58flbxmcbpwyw6vfwrd29fim21j6ac8";
        };
      buildInputs =
        [ gtk_doc pkgconfig gobjectIntrospection intltool libgudev
          polkit gcab appstream-glib gusb sqlite libarchive libsoup
          docbook2x libxslt libelf libsmbios fwupdate libyaml valgrind
        ];
      patchPhase = ''
        sed -i -e \
          's|/usr/bin/gpgme-config|${gpgme.dev}/bin/gpgme-config|' -e \
          's|/usr/bin/gpg-error-config|${libgpgerror.dev}/bin/gpg-error-config|' \
          ./configure
      '';
      preConfigure = ''
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${efivar}/include/efivar"
      '';
      configureFlags =
        [ "--with-systemdunitdir=$(out)/lib/systemd/system"
          "--with-udevrulesdir=$(out)/lib/udev/rules.d"
        ];
      enableParallelBuilding = true;
      meta =
        { license = [ stdenv.lib.licenses.gpl2 ];
          platforms = stdenv.lib.platforms.linux;
        };
    }
