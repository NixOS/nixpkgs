{ stdenv, fetchurl, fetchpatch, gtk-doc, pkgconfig, gobjectIntrospection, intltool
, libgudev, polkit, appstream-glib, gusb, sqlite, libarchive, glib-networking
, libsoup, help2man, gpgme, libxslt, elfutils, libsmbios, efivar, glibcLocales
, gnu-efi, libyaml, valgrind, meson, libuuid, colord, docbook_xml_dtd_43, docbook_xsl
, ninja, gcab, gnutls, python3, wrapGAppsHook, json-glib, bash-completion
, shared-mime-info, umockdev, vala, makeFontsConf, freefont_ttf
}:
let
  # Updating? Keep $out/etc synchronized with passthru.filesInstalledToEtc
  version = "1.1.0";
  python = python3.withPackages (p: with p; [ pygobject3 pycairo pillow ]);
  installedTestsPython = python3.withPackages (p: with p; [ pygobject3 requests ]);

  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };
in stdenv.mkDerivation {
  name = "fwupd-${version}";
  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
    sha256 = "0flfpzb0fxgixxddpwak4s63i35kr915pdfq5mfrnxq4bwcj24yd";
  };

  outputs = [ "out" "lib" "dev" "devdoc" "man" "installedTests" ];

  nativeBuildInputs = [
    meson ninja gtk-doc pkgconfig gobjectIntrospection intltool glibcLocales shared-mime-info
    valgrind gcab docbook_xml_dtd_43 docbook_xsl help2man libxslt python wrapGAppsHook vala
  ];
  buildInputs = [
    polkit appstream-glib gusb sqlite libarchive libsoup elfutils libsmbios gnu-efi libyaml
    libgudev colord gpgme libuuid gnutls glib-networking efivar json-glib umockdev
    bash-completion
  ];

  LC_ALL = "en_US.UTF-8"; # For po/make-images

  patches = [
    ./fix-paths.patch

    # Allow localedir in lib output
    # https://github.com/hughsie/fwupd/pull/626
    (fetchpatch {
      url = https://github.com/hughsie/fwupd/commit/9822c387ea13419a0eb2624fcd13d50735cb89f8.patch;
      sha256 = "12bk6ga2hvsswpc4gal95l2z5a6gp3vdjq16zm2npligcvf37b6i";
    })
  ];

  postPatch = ''
    # needs a different set of modules than po/make-images
    escapedInterpreterLine=$(echo "${installedTestsPython}/bin/python3" | sed 's|\\|\\\\|g')
    sed -i -e "1 s|.*|#\!$escapedInterpreterLine|" data/installed-tests/hardware.py

    patchShebangs .
    substituteInPlace data/installed-tests/fwupdmgr.test.in --subst-var-by installedtestsdir "$installedTests/share/installed-tests/fwupd"
  '';

  # /etc/os-release not available in sandbox
  # doCheck = true;

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${shared-mime-info}/share")
  '';

  mesonFlags = [
    "-Dplugin_dummy=true"
    "-Dudevdir=lib/udev"
    "-Dsystemdunitdir=lib/systemd/system"
    "-Defi-libdir=${gnu-efi}/lib"
    "-Defi-ldsdir=${gnu-efi}/lib"
    "-Defi-includedir=${gnu-efi}/include/efi"
    "--localstatedir=/var"
  ];

  # TODO: We need to be able to override the directory flags from meson setup hook
  # better – declaring them multiple times might become an error.
  preConfigure = ''
    mesonFlagsArray+=("--libexecdir=$out/libexec")
  '';

  postInstall = ''
    moveToOutput share/installed-tests "$installedTests"
    wrapProgram $installedTests/share/installed-tests/fwupd/hardware.py \
      --prefix GI_TYPELIB_PATH : "$out/lib/girepository-1.0:${libsoup}/lib/girepository-1.0"
  '';

  FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

  # /etc/fwupd/uefi.conf is created by the services.hardware.fwupd NixOS module
  passthru = {
    filesInstalledToEtc = [
      "fwupd/remotes.d/fwupd.conf"
      "fwupd/remotes.d/lvfs-testing.conf"
      "fwupd/remotes.d/lvfs.conf"
      "fwupd/remotes.d/vendor.conf"
      "pki/fwupd/GPG-KEY-Hughski-Limited"
      "pki/fwupd/GPG-KEY-Linux-Foundation-Metadata"
      "pki/fwupd/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd/LVFS-CA.pem"
      "pki/fwupd-metadata/GPG-KEY-Linux-Foundation-Metadata"
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
