{ stdenv, fetchurl, gtk_doc, pkgconfig, gobjectIntrospection, intltool
, libgudev, polkit, appstream-glib, gusb, sqlite, libarchive
, libsoup, docbook2x, gpgme, libxslt, libelf, libsmbios, efivar
, fwupdate, libyaml, valgrind, meson, libuuid, pygobject3
, pillow, ninja, gcab
}:
let version = "0.9.6";
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
          meson gpgme libuuid pygobject3 pillow ninja gcab
        ];
      patches = [ ./fix-missing-deps.patch ];
      preConfigure = ''
        export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE -I${efivar}/include/efivar"
      '';
      mesonFlags = [ "-Denable-colorhug=false" "-Denable-man=false" "-Denable-tests=false" "--localstatedir=/var" "-Denable-doc=false" "-Dwith-bootdir=/boot" ];
      enableParallelBuilding = true;
      meta =
        { license = [ stdenv.lib.licenses.gpl2 ];
          platforms = stdenv.lib.platforms.linux;
        };
    }
