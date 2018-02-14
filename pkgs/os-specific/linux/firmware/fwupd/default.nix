{ stdenv, fetchurl, fetchpatch, gtk_doc, pkgconfig, gobjectIntrospection, intltool
, libgudev, polkit, appstream-glib, gusb, sqlite, libarchive, glib_networking
, libsoup, docbook2x, gpgme, libxslt, elfutils, libsmbios, efivar, glibcLocales
, fwupdate, libyaml, valgrind, meson, libuuid, pygobject3, colord
, pillow, ninja, gcab, gnutls, python3Packages, wrapGAppsHook, json_glib
, shared_mime_info, umockdev
}:
let
  version = "1.0.4";
in stdenv.mkDerivation {
  name = "fwupd-${version}";
  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
    sha256 = "1n4d6fw3ffg051072hbxn106s52x2wlh5dh2kxwdfjsb5kh03ra3";
  };

  outputs = [ "out" "installedTests" ];

  nativeBuildInputs = [
    meson ninja gtk_doc pkgconfig gobjectIntrospection intltool glibcLocales shared_mime_info
    valgrind gcab docbook2x libxslt pygobject3 python3Packages.pycairo wrapGAppsHook
  ];
  buildInputs = [
    polkit appstream-glib gusb sqlite libarchive libsoup elfutils libsmbios fwupdate libyaml
    libgudev colord gpgme libuuid pillow gnutls glib_networking efivar json_glib umockdev
  ];

  LC_ALL = "en_US.UTF-8"; # For po/make-images

  patches = [
    ./fix-missing-deps.patch
    # https://github.com/hughsie/fwupd/issues/403
    (fetchpatch {
      url = https://github.com/hughsie/fwupd/commit/bd6082574989e4f48b66c7270bb408d439b77a06.patch;
      sha256 = "17pixyizkmn6wlsjmr1wwya17ivn770hdv9mp769vifxinya8w9y";
    })
  ];
  postPatch = ''
    patchShebangs .
    substituteInPlace data/installed-tests/fwupdmgr.test.in --subst-var-by installedtestsdir "$installedTests/share/installed-tests/fwupd"
  '';

  doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared_mime_info}/share")
  '';

  mesonFlags = [
    "-Dman=false"
    "-Dgtkdoc=false"
    "-Dbootdir=/boot"
    "-Dudevdir=lib/udev"
    "-Dsystemdunitdir=lib/systemd/system"
    "--localstatedir=/var"
  ];

  postInstall = ''
    moveToOutput share/installed-tests "$installedTests"
  '';

  enableParallelBuilding = true;
  meta = with stdenv.lib; {
    homepage = https://fwupd.org/;
    maintainers = with maintainers; [];
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
