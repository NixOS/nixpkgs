{ stdenv, fetchurl, gtk_doc, pkgconfig, gobjectIntrospection, intltool
, libgudev, polkit, appstream-glib, gusb, sqlite, libarchive
, libsoup, docbook2x, gpgme, libxslt, libelf, libsmbios, efivar
, fwupdate, libgpgerror, libyaml, valgrind, meson, libuuid, pygobject3
, pillow, ninja, gcab, makeWrapper, glib, gdk_pixbuf
}:
let version = "0.9.6";
    rpath = stdenv.lib.makeLibraryPath
      [ libuuid.out
        appstream-glib
        glib
        libsoup
        gdk_pixbuf
        libarchive.lib
        gcab
        sqlite.out
        gusb
        polkit.out
        gpgme
        libgpgerror
        libelf
        efivar
        libsmbios
        fwupdate
        libgudev
        "$out"
      ];
in
  stdenv.mkDerivation
    { name = "fwupd-${version}";
      src = fetchurl
        { url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
          sha256 = "0h3y4ygckvkjdx7yxwbm273iv84yk37ivlcf4xvq95g64vs8gfhf";
        };
      buildInputs =
        [ gtk_doc pkgconfig gobjectIntrospection intltool libgudev
          polkit appstream-glib gusb sqlite libarchive libsoup
          docbook2x libxslt libelf libsmbios fwupdate libyaml valgrind
          meson gpgme libuuid pygobject3 pillow ninja gcab makeWrapper
        ];
      patches = [ ./fix-missing-deps.patch ];
      preConfigure = ''
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${efivar}/include/efivar"
      '';
      mesonFlags = [ "-Denable-colorhug=false" "-Denable-man=false" "-Denable-tests=false" "--localstatedir=/var" "-Denable-doc=false" "-Dwith-bootdir=/boot" ];
      postFixup = ''
        for prog in $out/bin/* $out/libexec/fwupd/*; do
          wrapProgram "$prog" --prefix LD_LIBRARY_PATH : ${rpath}
        done
      '';
      enableParallelBuilding = true;
      meta =
        { license = [ stdenv.lib.licenses.gpl2 ];
          platforms = stdenv.lib.platforms.linux;
        };
    }
