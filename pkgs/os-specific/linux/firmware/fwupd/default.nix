# Updating? Keep $out/etc synchronized with passthru keys

{ stdenv
, lib
, fetchurl
, fetchpatch
, fetchFromGitHub
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
, curl
, libjcat
, libxslt
, elfutils
, libsmbios
, efivar
, valgrind
, meson
, libuuid
, colord
, docbook_xml_dtd_43
, docbook-xsl-nons
, ninja
, gcab
, gnutls
, protobufc
, python3
, wrapGAppsHook
, json-glib
, bash-completion
, shared-mime-info
, umockdev
, vala
, makeFontsConf
, freefont_ttf
, pango
, tpm2-tss
, bubblewrap
, efibootmgr
, flashrom
, tpm2-tools
, fwupd-efi
, nixosTests
, runCommand
, unstableGitUpdater
}:

let
  python = python3.withPackages (p: with p; [
    pygobject3
    setuptools
  ]);

  isx86 = stdenv.isx86_64 || stdenv.isi686;

  # Dell isn't supported on Aarch64
  haveDell = isx86;

  # only redfish for x86_64
  haveRedfish = stdenv.isx86_64;

  # only use msr if x86 (requires cpuid)
  haveMSR = isx86;

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

  test-firmware =
    let
      version = "unstable-2021-11-02";
      src = fetchFromGitHub {
        name = "fwupd-test-firmware-${version}";
        owner = "fwupd";
        repo = "fwupd-test-firmware";
        rev = "aaa2f9fd68a40684c256dd85b86093cba38ffd9d";
        sha256 = "Slk7CNfkmvmOh3WtIBkPs3NYT96co6i8PwqcbpeVFgA=";
        passthru = {
          inherit src version; # For update script
          updateScript = unstableGitUpdater {
            url = "${test-firmware.meta.homepage}.git";
          };
        };
      };
    in
      src // {
        meta = src.meta // {
          # For update script
          position =
            let
              pos = builtins.unsafeGetAttrPos "updateScript" test-firmware;
            in
            pos.file + ":" + toString pos.line;
        };
      };


  self = stdenv.mkDerivation rec {
    pname = "fwupd";
    version = "1.7.1";

    # libfwupd goes to lib
    # daemon, plug-ins and libfwupdplugin go to out
    # CLI programs go to out
    outputs = [ "out" "lib" "dev" "devdoc" "man" "installedTests" ];

    src = fetchurl {
      url = "https://people.freedesktop.org/~hughsient/releases/fwupd-${version}.tar.xz";
      sha256 = "sha256-rlbOtEt4byH1TRM6xwvF2cuM1L2gFnM5xmmiKNpn+jw=";
    };

    patches = [
      # Since /etc is the domain of NixOS, not Nix,
      # we cannot install files there.
      # Let’s install the files to $prefix/etc
      # while still reading them from /etc.
      # NixOS module for fwupd will take take care of copying the files appropriately.
      ./add-option-for-installation-sysconfdir.patch

      # Install plug-ins and libfwupdplugin to $out output,
      # they are not really part of the library.
      ./install-fwupdplugin-to-out.patch

      # Installed tests are installed to different output
      # we also cannot have fwupd-tests.conf in $out/etc since it would form a cycle.
      ./installed-tests-path.patch

      # Tests detect fwupd is installed when prefix is /usr.
      ./fix-install-detection.patch
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
      gnutls
      docbook_xml_dtd_43
      docbook-xsl-nons
      libxslt
      protobufc # for protoc
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
      curl
      elfutils
      libgudev
      colord
      libjcat
      libuuid
      json-glib
      umockdev
      bash-completion
      pango
      tpm2-tss
      efivar
      fwupd-efi
      protobufc
    ] ++ lib.optionals haveDell [
      libsmbios
    ];

    mesonFlags = [
      "-Ddocs=gtkdoc"
      "-Dplugin_dummy=true"
      # We are building the official releases.
      "-Dsupported_build=true"
      # Would dlopen libsoup to preserve compatibility with clients linking against older fwupd.
      # https://github.com/fwupd/fwupd/commit/173d389fa59d8db152a5b9da7cc1171586639c97
      "-Dsoup_session_compat=false"
      "-Dudevdir=lib/udev"
      "-Dsystemd_root_prefix=${placeholder "out"}"
      "-Dinstalled_test_prefix=${placeholder "installedTests"}"
      "--localstatedir=/var"
      "--sysconfdir=/etc"
      "-Dsysconfdir_install=${placeholder "out"}/etc"
      "-Defi_os_dir=nixos"

      # We do not want to place the daemon into lib (cyclic reference)
      "--libexecdir=${placeholder "out"}/libexec"
      # Our builder only adds $lib/lib to rpath but some things link
      # against libfwupdplugin which is in $out/lib.
      "-Dc_link_args=-Wl,-rpath,${placeholder "out"}/lib"
    ] ++ lib.optionals (!haveDell) [
      "-Dplugin_dell=false"
      "-Dplugin_synaptics=false"
    ] ++ lib.optionals (!haveRedfish) [
      "-Dplugin_redfish=false"
    ] ++ lib.optionals haveFlashrom [
      "-Dplugin_flashrom=true"
    ] ++ lib.optionals (!haveMSR) [
      "-Dplugin_msr=false"
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
        contrib/generate-version-script.py \
        meson_post_install.sh \
        po/test-deps
    '';

    preCheck = ''
      addToSearchPath XDG_DATA_DIRS "${shared-mime-info}/share"
    '';

    preInstall = ''
      # We have pkexec on PATH so Meson will try to use it when installation fails
      # due to being unable to write to e.g. /etc.
      # Let’s pretend we already ran pkexec –
      # the pkexec on PATH would complain it lacks setuid bit,
      # obscuring the underlying error.
      # https://github.com/mesonbuild/meson/blob/492cc9bf95d573e037155b588dc5110ded4d9a35/mesonbuild/minstall.py#L558
      export PKEXEC_UID=-1
    '';

    postInstall = ''
      # These files have weird licenses so they are shipped separately.
      cp --recursive --dereference "${test-firmware}/installed-tests/tests" "$installedTests/libexec/installed-tests/fwupd"
    '';

    preFixup = let
      binPath = [
        efibootmgr
        bubblewrap
        tpm2-tools
      ] ++ lib.optional haveFlashrom flashrom;
    in ''
      gappsWrapperArgs+=(
        --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
        # See programs reached with fu_common_find_program_in_path in source
        --prefix PATH : "${lib.makeBinPath binPath}"
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
        "fwupd/daemon.conf"
        "fwupd/remotes.d/lvfs-testing.conf"
        "fwupd/remotes.d/lvfs.conf"
        "fwupd/remotes.d/vendor.conf"
        "fwupd/remotes.d/vendor-directory.conf"
        "fwupd/thunderbolt.conf"
        "fwupd/uefi_capsule.conf"
        "pki/fwupd/GPG-KEY-Linux-Foundation-Firmware"
        "pki/fwupd/GPG-KEY-Linux-Vendor-Firmware-Service"
        "pki/fwupd/LVFS-CA.pem"
        "pki/fwupd-metadata/GPG-KEY-Linux-Foundation-Metadata"
        "pki/fwupd-metadata/GPG-KEY-Linux-Vendor-Firmware-Service"
        "pki/fwupd-metadata/LVFS-CA.pem"
        "grub.d/35_fwupd"
      ] ++ lib.optionals haveDell [
        "fwupd/remotes.d/dell-esrt.conf"
      ] ++ lib.optionals haveRedfish [
        "fwupd/redfish.conf"
      ];

      # DisabledPlugins key in fwupd/daemon.conf
      defaultDisabledPlugins = [
        "test"
        "test_ble"
        "invalid"
      ];

      # For updating.
      inherit test-firmware;

      tests = let
        listToPy = list: "[${lib.concatMapStringsSep ", " (f: "'${f}'") list}]";
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

    meta = with lib; {
      homepage = "https://fwupd.org/";
      maintainers = with maintainers; [ jtojnar ];
      license = licenses.lgpl21Plus;
      platforms = platforms.linux;
    };
  };

in self
