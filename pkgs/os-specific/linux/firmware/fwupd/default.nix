{ stdenv, fetchurl, fetchpatch, gtk_doc, pkgconfig, gobjectIntrospection, intltool
, libgudev, polkit, appstream-glib, gusb, sqlite, libarchive, glib_networking
, libsoup, docbook2x, gpgme, libxslt, elfutils, libsmbios, efivar, glibcLocales
, fwupdate, libyaml, valgrind, meson, libuuid, colord
, ninja, gcab, gnutls, python3, wrapGAppsHook, json_glib
, shared_mime_info, umockdev
}:
let
  version = "1.0.4";
  python = python3.withPackages (p: with p; [ pygobject3 pycairo pillow ]);
  installedTestsPython = python3.withPackages (p: with p; [ pygobject3 requests ]);
in stdenv.mkDerivation {
  name = "fwupd-${version}";
  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
    sha256 = "1n4d6fw3ffg051072hbxn106s52x2wlh5dh2kxwdfjsb5kh03ra3";
  };

  outputs = [ "out" "installedTests" ];

  nativeBuildInputs = [
    meson ninja gtk_doc pkgconfig gobjectIntrospection intltool glibcLocales shared_mime_info
    valgrind gcab docbook2x libxslt python wrapGAppsHook
  ];
  buildInputs = [
    polkit appstream-glib gusb sqlite libarchive libsoup elfutils libsmbios fwupdate libyaml
    libgudev colord gpgme libuuid gnutls glib_networking efivar json_glib umockdev
  ];

  LC_ALL = "en_US.UTF-8"; # For po/make-images

  patches = [
    ./fix-missing-deps.patch
    # https://github.com/hughsie/fwupd/issues/403
    (fetchpatch {
      url = https://github.com/hughsie/fwupd/commit/bd6082574989e4f48b66c7270bb408d439b77a06.patch;
      sha256 = "17pixyizkmn6wlsjmr1wwya17ivn770hdv9mp769vifxinya8w9y";
    })
    # https://github.com/hughsie/fwupd/issues/405
    (fetchpatch {
      url = https://github.com/hughsie/fwupd/pull/407.patch;
      sha256 = "1dxhqps12x7bz0s974xk5hfpk4nwn1gs29vl0dfi9j54wy18f688";
    })
  ];

  postPatch = ''
    # needs a different set of modules than po/make-images
    escapedInterpreterLine=$(echo "${installedTestsPython}/bin/python3" | sed 's|\\|\\\\|g')
    sed -i -e "1 s|.*|#\!$escapedInterpreterLine|" data/installed-tests/hardware.py

    patchShebangs .
    substituteInPlace data/installed-tests/fwupdmgr.test.in --subst-var-by installedtestsdir "$installedTests/share/installed-tests/fwupd"
  '';

  doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared_mime_info}/share")
  '';

  mesonFlags = [
    "-Dman=false"
    "-Dplugin_dummy=true"
    "-Dgtkdoc=false"
    "-Dbootdir=/boot"
    "-Dudevdir=lib/udev"
    "-Dsystemdunitdir=lib/systemd/system"
    "--localstatedir=/var"
  ];

  postInstall = ''
    moveToOutput share/installed-tests "$installedTests"
    wrapProgram $installedTests/share/installed-tests/fwupd/hardware.py \
      --prefix GI_TYPELIB_PATH : "$out/lib/girepository-1.0:${libsoup}/lib/girepository-1.0"
  '';

  enableParallelBuilding = true;
  meta = with stdenv.lib; {
    homepage = https://fwupd.org/;
    maintainers = with maintainers; [];
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
