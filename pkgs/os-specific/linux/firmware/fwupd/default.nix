{ stdenv, fetchurl, gtk_doc, pkgconfig, gobjectIntrospection, intltool
, libgudev, polkit, gcab, appstream-glib, gusb, sqlite, libarchive
, libsoup, docbook2x, gpgme, libxslt, libelf, libsmbios, efivar
, fwupdate, libgpgerror, libyaml
}:
let version = "0.8.0"; in
  stdenv.mkDerivation
    { name = "fwupd-${version}";
      src = fetchurl
        { url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
          sha256 = "1irr7xr0slfpm7pvlc9ysy85d51fv0gss6cv0w4sc5p7rhvjx69g";
        };
      buildInputs =
        [ gtk_doc pkgconfig gobjectIntrospection intltool libgudev
          polkit gcab appstream-glib gusb sqlite libarchive libsoup
          docbook2x libxslt libelf libsmbios fwupdate libyaml
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
        [ "--with-systemdunitdir=$out/lib/systemd/system"
          "--with-udevrulesdir=$out/lib/udev/rules.d"
        ];
      enableParallelBuilding = true;
      meta =
        { license = [ stdenv.lib.licenses.gpl2 ];
          platforms = stdenv.lib.platforms.linux;
        };
    }
