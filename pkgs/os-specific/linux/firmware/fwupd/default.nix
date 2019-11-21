# Updating? Keep $out/etc synchronized with passthru.filesInstalledToEtc

{ stdenv
, fetchurl
, substituteAll
, gtk-doc
, pkgconfig
, gobject-introspection
, intltool
, libgudev
, polkit
, libxmlb
, gusb
, sqlite
, libarchive
, glib-networking
, libsoup
, help2man
, gpgme
, libxslt
, elfutils
, libsmbios
, efivar
, gnu-efi
, libyaml
, valgrind
, meson
, libuuid
, colord
, docbook_xml_dtd_43
, docbook_xsl
, ninja
, gcab
, gnutls
, python3
, wrapGAppsHook
, json-glib
, bash-completion
, shared-mime-info
, umockdev
, vala
, makeFontsConf
, freefont_ttf
, cairo
, freetype
, fontconfig
, pango
, tpm2-tss
, bubblewrap
, efibootmgr
, flashrom
, tpm2-tools
, nixosTests
}:

let
  python = python3.withPackages (p: with p; [
    pygobject3
    pycairo
    pillow
    setuptools
  ]);

  installedTestsPython = python3.withPackages (p: with p; [
    pygobject3
    requests
  ]);

  fontsConf = makeFontsConf {
    fontDirectories = [ freefont_ttf ];
  };

  isx86 = stdenv.isx86_64 || stdenv.isi686;

  # Dell isn't supported on Aarch64
  haveDell = isx86;

  # only redfish for x86_64
  haveRedfish = stdenv.isx86_64;

  # # Currently broken on Aarch64
  # haveFlashrom = isx86;
  # Experimental
  haveFlashrom = false;

in

stdenv.mkDerivation rec {
  pname = "fwupd";
  version = "1.3.3";

  src = fetchurl {
    url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
    sha256 = "0nqzqvx8nzflhb4kzvkdcv7kixb50vh6h21kpkd7pjxp942ndzql";
  };

  outputs = [ "out" "lib" "dev" "devdoc" "man" "installedTests" ];

  nativeBuildInputs = [
    meson
    ninja
    gtk-doc
    pkgconfig
    gobject-introspection
    intltool
    shared-mime-info
    valgrind
    gcab
    docbook_xml_dtd_43
    docbook_xsl
    help2man
    libxslt
    python
    wrapGAppsHook
    vala
  ];

  buildInputs = [
    polkit
    libxmlb
    gusb
    sqlite
    libarchive
    libsoup
    elfutils
    gnu-efi
    libyaml
    libgudev
    colord
    gpgme
    libuuid
    gnutls
    glib-networking
    json-glib
    umockdev
    bash-completion
    cairo
    freetype
    fontconfig
    pango
    tpm2-tss
    efivar
  ] ++ stdenv.lib.optionals haveDell [
    libsmbios
  ];

  patches = [
    ./fix-paths.patch
    ./add-option-for-installation-sysconfdir.patch

    # do not require which
    # https://github.com/fwupd/fwupd/pull/1568
    ./no-which.patch

    # installed tests are installed to different output
    # we also cannot have fwupd-tests.conf in $out/etc since it would form a cycle
    (substituteAll {
      src = ./installed-tests-path.patch;
      # needs a different set of modules than po/make-images
      inherit installedTestsPython;
    })
  ];

  postPatch = ''
    patchShebangs \
      libfwupd/generate-version-script.py \
      meson_post_install.sh \
      po/make-images \
      po/make-images.sh \
      po/test-deps

    # we cannot use placeholder in substituteAll
    # https://github.com/NixOS/nix/issues/1846
    substituteInPlace data/installed-tests/meson.build --subst-var installedTests

    # install plug-ins to out, they are not really part of the library
    substituteInPlace meson.build \
      --replace "plugin_dir = join_paths(libdir, 'fwupd-plugins-3')" \
                "plugin_dir = join_paths('${placeholder "out"}', 'fwupd_plugins-3')"

    substituteInPlace data/meson.build --replace \
      "install_dir: systemd.get_pkgconfig_variable('systemdshutdowndir')" \
      "install_dir: '${placeholder "out"}/lib/systemd/system-shutdown'"
  '';

  # /etc/os-release not available in sandbox
  # doCheck = true;

  preFixup = let
    binPath = [
      efibootmgr
      bubblewrap
      tpm2-tools
    ] ++ stdenv.lib.optional haveFlashrom flashrom;
  in ''
    gappsWrapperArgs+=(
      --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
      # See programs reached with fu_common_find_program_in_path in source
      --prefix PATH : "${stdenv.lib.makeBinPath binPath}"
    )
  '';

  mesonFlags = [
    "-Dgtkdoc=true"
    "-Dplugin_dummy=true"
    "-Dudevdir=lib/udev"
    "-Dsystemdunitdir=lib/systemd/system"
    "-Defi-libdir=${gnu-efi}/lib"
    "-Defi-ldsdir=${gnu-efi}/lib"
    "-Defi-includedir=${gnu-efi}/include/efi"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    "--libexecdir=${placeholder "out"}/libexec"
  ] ++ stdenv.lib.optionals (!haveDell) [
    "-Dplugin_dell=false"
    "-Dplugin_synaptics=false"
  ] ++ stdenv.lib.optionals (!haveRedfish) [
    "-Dplugin_redfish=false"
  ] ++ stdenv.lib.optionals haveFlashrom [
    "-Dplugin_flashrom=true"
  ];

  postInstall = ''
    moveToOutput share/installed-tests "$installedTests"
    wrapProgram $installedTests/share/installed-tests/fwupd/hardware.py \
      --prefix GI_TYPELIB_PATH : "$out/lib/girepository-1.0:${libsoup}/lib/girepository-1.0"
  '';

  FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

  # error: “PolicyKit files are missing”
  # https://github.com/NixOS/nixpkgs/pull/67625#issuecomment-525788428
  PKG_CONFIG_POLKIT_GOBJECT_1_ACTIONDIR = "/run/current-system/sw/share/polkit-1/actions";

  # cannot install to systemd prefix
  PKG_CONFIG_SYSTEMD_SYSTEMDSYSTEMPRESETDIR = "${placeholder "out"}/lib/systemd/system-preset";

  # TODO: wrapGAppsHook wraps efi capsule even though it is not elf
  dontWrapGApps = true;
  # so we need to wrap the executables manually
  postFixup = ''
    find -L "$out/bin" "$out/libexec" -type f -executable -print0 \
      | while IFS= read -r -d ''' file; do
      if [[ "$file" != *.efi ]]; then
        echo "Wrapping program $file"
        wrapGApp "$file"
      fi
    done
  '';

  # /etc/fwupd/uefi.conf is created by the services.hardware.fwupd NixOS module
  passthru = {
    filesInstalledToEtc = [
      # "fwupd/daemon.conf" # already created by the module
      "fwupd/redfish.conf"
      "fwupd/remotes.d/dell-esrt.conf"
      "fwupd/remotes.d/lvfs-testing.conf"
      "fwupd/remotes.d/lvfs.conf"
      "fwupd/remotes.d/vendor.conf"
      "fwupd/remotes.d/vendor-directory.conf"
      "fwupd/thunderbolt.conf"
      # "fwupd/uefi.conf" # already created by the module
      "pki/fwupd/GPG-KEY-Hughski-Limited"
      "pki/fwupd/GPG-KEY-Linux-Foundation-Firmware"
      "pki/fwupd/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd/LVFS-CA.pem"
      "pki/fwupd-metadata/GPG-KEY-Linux-Foundation-Metadata"
      "pki/fwupd-metadata/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd-metadata/LVFS-CA.pem"
    ];

    tests = {
      installedTests = nixosTests.installed-tests.fwupd;
    };
  };

  meta = with stdenv.lib; {
    homepage = "https://fwupd.org/";
    maintainers = with maintainers; [ jtojnar ];
    license = [ licenses.gpl2 ];
    platforms = platforms.linux;
  };
}
