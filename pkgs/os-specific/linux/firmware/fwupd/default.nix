{ stdenv, fetchurl, fetchpatch, gtk-doc, pkgconfig, gobjectIntrospection, intltool
, libgudev, polkit, appstream-glib, gusb, sqlite, libarchive, glib-networking
, libsoup, help2man, gpgme, libxslt, elfutils, libsmbios, efivar, glibcLocales
, fwupdate, libyaml, valgrind, meson, libuuid, colord, docbook_xml_dtd_43, docbook_xsl
, ninja, gcab, gnutls, python3, wrapGAppsHook, json-glib
, shared-mime-info, umockdev
}:
let
  # Updating? Keep $out/etc synchronized with passthru.filesInstalledToEtc
  version = "1.0.5";
  python = python3.withPackages (p: with p; [ pygobject3 pycairo pillow ]);
  installedTestsPython = python3.withPackages (p: with p; [ pygobject3 requests ]);
in stdenv.mkDerivation {
  name = "fwupd-${version}";
  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
    sha256 = "0wm195vkf6x1kg1dz0sbfwpdcn9f6638l7vyzplcfrb3v07pqxpq";
  };

  outputs = [ "out" "devdoc" "man" "installedTests" ];

  nativeBuildInputs = [
    meson ninja gtk-doc pkgconfig gobjectIntrospection intltool glibcLocales shared-mime-info
    valgrind gcab docbook_xml_dtd_43 docbook_xsl help2man libxslt python wrapGAppsHook
  ];
  buildInputs = [
    polkit appstream-glib gusb sqlite libarchive libsoup elfutils libsmbios fwupdate libyaml
    libgudev colord gpgme libuuid gnutls glib-networking efivar json-glib umockdev
  ];

  LC_ALL = "en_US.UTF-8"; # For po/make-images

  patches = [
    ./fix-missing-deps.patch
    (fetchpatch {
      url = https://github.com/hughsie/fwupd/commit/767210e4b1401d5d5bb7ac1e7c052a60b6529d88.patch;
      sha256 = "00adfabxpgdg74jx7i6jihhh8njjk2r7v3fxqs4scj3vn06k5fmw";
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
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  mesonFlags = [
    "-Dplugin_dummy=true"
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

  passthru = {
    filesInstalledToEtc = [
      "fwupd/remotes.d/fwupd.conf"
      "fwupd/remotes.d/lvfs-testing.conf"
      "fwupd/remotes.d/lvfs.conf"
      "fwupd/remotes.d/vendor.conf"
      "pki/fwupd/GPG-KEY-Hughski-Limited"
      "pki/fwupd/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd/LVFS-CA.pem"
      "pki/fwupd-metadata/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd-metadata/LVFS-CA.pem"
    ];
  };

  meta = with stdenv.lib; {
    homepage = https://fwupd.org/;
    maintainers = with maintainers; [];
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
