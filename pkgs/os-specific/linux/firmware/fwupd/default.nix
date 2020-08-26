# Updating? Keep $out/etc synchronized with passthru keys

{ stdenv
, fetchurl
, fetchpatch
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
, libjcat
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
, runCommand
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

  runPythonCommand = name: buildCommandPython: runCommand name {
    nativeBuildInputs = [ python3 ];
      inherit buildCommandPython;
  } ''
    exec python3 -c "$buildCommandPython"
  '';

  self = stdenv.mkDerivation rec {
    pname = "fwupd";
    version = "1.4.5";

    src = fetchurl {
      url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
      sha256 = "0hpqxwqbbqn440c2swpnc06z8dskisrli4ynsxrzzqyp0dan46xw";
    };

    # libfwupd goes to lib
    # daemon, plug-ins and libfwupdplugin go to out
    # CLI programs go to out
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
      libjcat
      libuuid
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

      # Install plug-ins and libfwupdplugin to out,
      # they are not really part of the library.
      ./install-fwupdplugin-to-out.patch

      # Installed tests are installed to different output
      # we also cannot have fwupd-tests.conf in $out/etc since it would form a cycle.
      (substituteAll {
        src = ./installed-tests-path.patch;
        # Needs a different set of modules than po/make-images.
        inherit installedTestsPython;
      })
    ];

    postPatch = ''
      patchShebangs \
        contrib/get-version.py \
        contrib/generate-version-script.py \
        meson_post_install.sh \
        po/make-images \
        po/make-images.sh \
        po/test-deps
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
      "-Dsystemd_root_prefix=${placeholder "out"}"
      "-Dinstalled_test_prefix=${placeholder "installedTests"}"
      "-Defi-libdir=${gnu-efi}/lib"
      "-Defi-ldsdir=${gnu-efi}/lib"
      "-Defi-includedir=${gnu-efi}/include/efi"
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "-Dsysconfdir_install=${placeholder "out"}/etc"

      # We do not want to place the daemon into lib (cyclic reference)
      "--libexecdir=${placeholder "out"}/libexec"
      # Our builder only adds $lib/lib to rpath but some things link
      # against libfwupdplugin which is in $out/lib.
      "-Dc_link_args=-Wl,-rpath,${placeholder "out"}/lib"
    ] ++ stdenv.lib.optionals (!haveDell) [
      "-Dplugin_dell=false"
      "-Dplugin_synaptics=false"
    ] ++ stdenv.lib.optionals (!haveRedfish) [
      "-Dplugin_redfish=false"
    ] ++ stdenv.lib.optionals haveFlashrom [
      "-Dplugin_flashrom=true"
    ];

    FONTCONFIG_FILE = fontsConf; # Fontconfig error: Cannot load default config file

    # error: “PolicyKit files are missing”
    # https://github.com/NixOS/nixpkgs/pull/67625#issuecomment-525788428
    PKG_CONFIG_POLKIT_GOBJECT_1_ACTIONDIR = "/run/current-system/sw/share/polkit-1/actions";

    # TODO: wrapGAppsHook wraps efi capsule even though it is not elf
    dontWrapGApps = true;

    preCheck = ''
      addToSearchPath XDG_DATA_DIRS "${shared-mime-info}/share"
    '';

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

    passthru = {
      filesInstalledToEtc = [
        "fwupd/ata.conf"
        "fwupd/daemon.conf"
        "fwupd/redfish.conf"
        "fwupd/remotes.d/lvfs-testing.conf"
        "fwupd/remotes.d/lvfs.conf"
        "fwupd/remotes.d/vendor.conf"
        "fwupd/remotes.d/vendor-directory.conf"
        "fwupd/thunderbolt.conf"
        "fwupd/upower.conf"
        "fwupd/uefi.conf"
        "pki/fwupd/GPG-KEY-Hughski-Limited"
        "pki/fwupd/GPG-KEY-Linux-Foundation-Firmware"
        "pki/fwupd/GPG-KEY-Linux-Vendor-Firmware-Service"
        "pki/fwupd/LVFS-CA.pem"
        "pki/fwupd-metadata/GPG-KEY-Linux-Foundation-Metadata"
        "pki/fwupd-metadata/GPG-KEY-Linux-Vendor-Firmware-Service"
        "pki/fwupd-metadata/LVFS-CA.pem"
      ] ++ stdenv.lib.optionals haveDell [
        "fwupd/remotes.d/dell-esrt.conf"
      ];

      # BlacklistPlugins key in fwupd/daemon.conf
      defaultBlacklistedPlugins = [
        "test"
        "invalid"
      ];

      tests = let
        listToPy = list: "[${stdenv.lib.concatMapStringsSep ", " (f: "'${f}'") list}]";
      in {
        installedTests = nixosTests.installed-tests.fwupd;

        passthruMatches = runPythonCommand "fwupd-test-passthru-matches" ''
          import itertools
          import configparser
          import os
          import pathlib

          etc = '${self}/etc'
          package_etc = set(itertools.chain.from_iterable([[os.path.relpath(os.path.join(prefix, file), etc) for file in files] for (prefix, dirs, files) in os.walk(etc)]))
          passthru_etc = set(${listToPy passthru.filesInstalledToEtc})
          assert len(package_etc - passthru_etc) == 0, f'fwupd package contains the following paths in /etc that are not listed in passthru.filesInstalledToEtc: {package_etc - passthru_etc}'
          assert len(passthru_etc - package_etc) == 0, f'fwupd package lists the following paths in passthru.filesInstalledToEtc that are not contained in /etc: {passthru_etc - package_etc}'

          config = configparser.RawConfigParser()
          config.read('${self}/etc/fwupd/daemon.conf')
          package_blacklisted_plugins = config.get('fwupd', 'BlacklistPlugins').rstrip(';').split(';')
          passthru_blacklisted_plugins = ${listToPy passthru.defaultBlacklistedPlugins}
          assert package_blacklisted_plugins == passthru_blacklisted_plugins, f'Default blacklisted plug-ins in the package {package_blacklisted_plugins} do not match those listed in passthru.defaultBlacklistedPlugins {passthru_blacklisted_plugins}'

          pathlib.Path(os.getenv('out')).touch()
        '';
      };
    };

    meta = with stdenv.lib; {
      homepage = "https://fwupd.org/";
      maintainers = with maintainers; [ jtojnar ];
      license = [ licenses.gpl2 ];
      platforms = platforms.linux;
    };
  };

in self
