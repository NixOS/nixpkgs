{ stdenv, fetchurl, gtk_doc, pkgconfig, gobjectIntrospection, intltool
, libgudev, polkit, appstream-glib, gusb, sqlite, libarchive, glib_networking
, libsoup, docbook2x, gpgme, libxslt, libelf, libsmbios, efivar, glibcLocales
, fwupdate, libyaml, valgrind, meson, libuuid, pygobject3, colord
, pillow, ninja, gcab, gnutls, python3Packages, wrapGAppsHook, json_glib
}:
let
  version = "1.0.4";
in stdenv.mkDerivation {
  name = "fwupd-${version}";
  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
    sha256 = "1n4d6fw3ffg051072hbxn106s52x2wlh5dh2kxwdfjsb5kh03ra3";
  };

  nativeBuildInputs = [
    meson ninja gtk_doc pkgconfig gobjectIntrospection intltool glibcLocales
    valgrind gcab docbook2x libxslt pygobject3 python3Packages.pycairo wrapGAppsHook
  ];
  buildInputs = [
    polkit appstream-glib gusb sqlite libarchive libsoup libelf libsmbios fwupdate libyaml
    libgudev colord gpgme libuuid pillow gnutls glib_networking efivar json_glib
  ];

  LC_ALL = "en_US.UTF-8"; # For po/make-images

  patches = [
    ./fix-missing-deps.patch
  ];
  postPatch = ''
    patchShebangs .
  '';

  mesonFlags = [
    "-Dman=false"
    "-Dtests=false"
    "-Dgtkdoc=false"
    "-Dbootdir=/boot"
    "-Dudevdir=lib/udev"
    "-Dsystemdunitdir=lib/systemd/system"
    "--localstatedir=/var"
  ];

  enableParallelBuilding = true;
  meta = {
    homepage = https://fwupd.org/;
    license = [ stdenv.lib.licenses.gpl2 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
