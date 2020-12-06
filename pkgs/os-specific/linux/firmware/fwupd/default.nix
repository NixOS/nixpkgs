# Updating? Keep $out/etc synchronized with passthru keys

{ stdenv
, fetchurl
, fetchpatch
, fetchFromGitHub
, substituteAll
, gtk-doc
, pkg-config
, gobject-introspection
, gettext
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
, valgrind
, meson
, libuuid
, colord
, docbook_xml_dtd_43
, docbook-xsl-nons
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
    version = "1.5.1";

    # libfwupd goes to lib
    # daemon, plug-ins and libfwupdplugin go to out
    # CLI programs go to out
    outputs = [ "out" "lib" "dev" "devdoc" "man" "installedTests" ];

    src = fetchurl {
      url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
      sha256 = "0fpxcl6bighiipyl4qspjhi0lwisrgq8jdahm68mk34rmrx50sgf";
    };

    patches = [
      # Do not try to create useless paths in /var.
      ./fix-paths.patch

      # Allow installing
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

      # Skip tests requiring network.
      (fetchpatch {
        url = "https://github.com/fwupd/fwupd/commit/db15442c7c217610954786bd40779c14ed0e034b.patch";
        sha256 = "/jzpGMJcqLisjecKpSUfA8ZCU53n7BOPR6tMgEX/qL8=";
      })
    ];

    nativeBuildInputs = [
      meson
      ninja
      gtk-doc
      pkg-config
      gobject-introspection
      gettext
      shared-mime-info
      valgrind
      gcab
      docbook_xml_dtd_43
      docbook-xsl-nons
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

    # TODO: wrapGAppsHook wraps efi capsule even though it is not ELF
    dontWrapGApps = true;

    # /etc/os-release not available in sandbox
    # doCheck = true;

    # Environment variables

    # Fontconfig error: Cannot load default config file
    FONTCONFIG_FILE =
      let
        fontsConf = makeFontsConf {
          fontDirectories = [ freefont_ttf ];
        };
      in fontsConf;

    # error: “PolicyKit files are missing”
    # https://github.com/NixOS/nixpkgs/pull/67625#issuecomment-525788428
    PKG_CONFIG_POLKIT_GOBJECT_1_ACTIONDIR = "/run/current-system/sw/share/polkit-1/actions";

    # Phase hooks

    postPatch = ''
      patchShebangs \
        contrib/get-version.py \
        contrib/generate-version-script.py \
        meson_post_install.sh \
        po/make-images \
        po/make-images.sh \
        po/test-deps
    '';

    preCheck = ''
      addToSearchPath XDG_DATA_DIRS "${shared-mime-info}/share"
    '';

    postInstall =
      let
        testFw = fetchFromGitHub {
          owner = "fwupd";
          repo = "fwupd-test-firmware";
          rev = "42b62c62dc85ecfb8e38099fe5de0625af87a722";
          sha256 = "XUpxE003DZSeLJMtyV5UN5CNHH89/nEVKpCbMStm91Q=";
        };
      in ''
        # These files have weird licenses so they are shipped separately.
        cp --recursive --dereference "${testFw}/installed-tests/tests" "$installedTests/libexec/installed-tests/fwupd"
      '';

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

    # Since we had to disable wrapGAppsHook, we need to wrap the executables manually.
    postFixup = ''
      find -L "$out/bin" "$out/libexec" -type f -executable -print0 \
        | while IFS= read -r -d ''' file; do
        if [[ "$file" != *.efi ]]; then
          echo "Wrapping program $file"
          wrapGApp "$file"
        fi
      done
    '';

    separateDebugInfo = true;

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

      # DisabledPlugins key in fwupd/daemon.conf
      defaultDisabledPlugins = [
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
          package_disabled_plugins = config.get('fwupd', 'DisabledPlugins').rstrip(';').split(';')
          passthru_disabled_plugins = ${listToPy passthru.defaultDisabledPlugins}
          assert package_disabled_plugins == passthru_disabled_plugins, f'Default disabled plug-ins in the package {package_disabled_plugins} do not match those listed in passthru.defaultDisabledPlugins {passthru_disabled_plugins}'

          pathlib.Path(os.getenv('out')).touch()
        '';
      };
    };

    meta = with stdenv.lib; {
      homepage = "https://fwupd.org/";
      maintainers = with maintainers; [ jtojnar ];
      license = licenses.lgpl21Plus;
      platforms = platforms.linux;
    };
  };

in self
