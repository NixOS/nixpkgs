{ stdenv, fetchurl, gtk_doc, pkgconfig, gobjectIntrospection, intltool
, libgudev, polkit, appstream-glib, gusb, sqlite, libarchive, glib_networking
, libsoup, docbook2x, gpgme, libxslt, libelf, libsmbios, efivar, glibcLocales
, fwupdate, libyaml, valgrind, meson, libuuid, pygobject3, colord
, pillow, ninja, gcab, gnutls, python3Packages, wrapGAppsHook
}:
let
  version = "1.0.2";
in stdenv.mkDerivation {
  name = "fwupd-${version}";
  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
    sha256 = "15hrl6jq2kyvbxgjkv3qafqj2962il27gryakm39kvz2p2l1bacj";
  };

  nativeBuildInputs = [
    meson ninja gtk_doc pkgconfig gobjectIntrospection intltool glibcLocales
    valgrind gcab docbook2x libxslt pygobject3 python3Packages.pycairo wrapGAppsHook
  ];
  buildInputs = [
    polkit appstream-glib gusb sqlite libarchive libsoup libelf libsmbios fwupdate libyaml
    libgudev colord gpgme libuuid pillow gnutls glib_networking
  ];

  LC_ALL = "en_US.UTF-8"; # For po/make-images

  NIX_CFLAGS_COMPILE = [
    "-I${efivar}/include/efivar"
    # warning: "__LIBELF_INTERNAL__" is not defined
    "-Wno-error=undef"
  ];

  patches = [
    ./fix-missing-deps.patch
  ];
  postPatch = ''
    patchShebangs .
  '';

  mesonFlags = [
    "-Denable-man=false"
    "-Denable-tests=false"
    "-Denable-doc=false"
    "-Dwith-bootdir=/boot"
    "-Dwith-udevdir=lib/udev"
    "-Dwith-systemdunitdir=lib/systemd/system"
    "--localstatedir=/var"
  ];

  enableParallelBuilding = true;
  meta = {
    homepage = https://fwupd.org/;
    license = [ stdenv.lib.licenses.gpl2 ];
    platforms = stdenv.lib.platforms.linux;
  };
}
