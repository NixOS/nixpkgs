# Updating? Keep $out/etc synchronized with passthru keys

{ stdenv
, lib
, fetchFromGitHub
, gi-docgen
, pkg-config
, gobject-introspection
, gettext
, libgudev
, polkit
, libxmlb
, glib
, gusb
, sqlite
, libarchive
, libredirect
, curl
, libjcat
, elfutils
, libsmbios
, efivar
, valgrind
, meson
, libuuid
, colord
, ninja
, gcab
, gnutls
, protobufc
, python3
, wrapGAppsNoGuiHook
, ensureNewerSourcesForZipFilesHook
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
, modemmanager
, libqmi
, libmbim
, libcbor
, xz
, enableFlashrom ? false
, enablePassim ? false
}:

let
  python = python3.withPackages (p: with p; [
    jinja2
    pygobject3
    setuptools
  ]);

  isx86 = stdenv.hostPlatform.isx86;

  # Dell isn't supported on Aarch64
  haveDell = isx86;

  # only redfish for x86_64
  haveRedfish = stdenv.isx86_64;

  # only use msr if x86 (requires cpuid)
  haveMSR = isx86;

  # # Currently broken on Aarch64
  # haveFlashrom = isx86;
  # Experimental
  haveFlashrom = isx86 && enableFlashrom;

  runPythonCommand =
    name:
    buildCommandPython:

    runCommand
      name
      {
        nativeBuildInputs = [ python3 ];
        inherit buildCommandPython;
      }
      ''
        exec python3 -c "$buildCommandPython"
      '';

  test-firmware =
    let
      version = "unstable-2022-04-02";
      src = fetchFromGitHub {
        name = "fwupd-test-firmware-${version}";
        owner = "fwupd";
        repo = "fwupd-test-firmware";
        rev = "39954e434d63e20e85870dd1074818f48a0c08b7";
        hash = "sha256-d4qG3fKyxkfN91AplRYqARFz+aRr+R37BpE450bPxi0=";
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
in
stdenv.mkDerivation (finalAttrs: {
  pname = "fwupd";
  version = "1.9.5";

  # libfwupd goes to lib
  # daemon, plug-ins and libfwupdplugin go to out
  # CLI programs go to out
  outputs = [ "out" "lib" "dev" "devdoc" "man" "installedTests" ];

  src = fetchFromGitHub {
    owner = "fwupd";
    repo = "fwupd";
    rev = finalAttrs.version;
    hash = "sha256-dqbFgVgG2RQM5ZHIEIIJOmrjtwlaRXEyY+2OdDs4PGo=";
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

    # EFI capsule is located in fwupd-efi now.
    ./efi-app-path.patch
  ];

  nativeBuildInputs = [
    # required for firmware zipping
    ensureNewerSourcesForZipFilesHook
    meson
    ninja
    gi-docgen
    pkg-config
    gobject-introspection
    gettext
    shared-mime-info
    valgrind
    gcab
    gnutls
    protobufc # for protoc
    python
    wrapGAppsNoGuiHook
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
    modemmanager
    libmbim
    libcbor
    libqmi
    xz # for liblzma
  ] ++ lib.optionals haveDell [
    libsmbios
  ] ++ lib.optionals haveFlashrom [
    flashrom
  ];

  mesonFlags = [
    "-Ddocs=enabled"
    "-Dplugin_dummy=true"
    # We are building the official releases.
    "-Dsupported_build=enabled"
    "-Dudevdir=lib/udev"
    "-Dsystemd_root_prefix=${placeholder "out"}"
    "-Dinstalled_test_prefix=${placeholder "installedTests"}"
    "--localstatedir=/var"
    "--sysconfdir=/etc"
    "-Dsysconfdir_install=${placeholder "out"}/etc"
    "-Defi_os_dir=nixos"
    "-Dplugin_modem_manager=enabled"
    # We do not want to place the daemon into lib (cyclic reference)
    "--libexecdir=${placeholder "out"}/libexec"
  ] ++ lib.optionals (!enablePassim) [
    "-Dpassim=disabled"
  ] ++ lib.optionals (!haveDell) [
    "-Dplugin_dell=disabled"
    "-Dplugin_synaptics_mst=disabled"
  ] ++ lib.optionals (!haveRedfish) [
    "-Dplugin_redfish=disabled"
  ] ++ lib.optionals (!haveFlashrom) [
    "-Dplugin_flashrom=disabled"
  ] ++ lib.optionals (!haveMSR) [
    "-Dplugin_msr=disabled"
  ];

  # TODO: wrapGAppsHook wraps efi capsule even though it is not ELF
  dontWrapGApps = true;

  doCheck = true;

  # Environment variables

  # Fontconfig error: Cannot load default config file
  FONTCONFIG_FILE =
    let
      fontsConf = makeFontsConf {
        fontDirectories = [ freefont_ttf ];
      };
    in
    fontsConf;

  # error: “PolicyKit files are missing”
  # https://github.com/NixOS/nixpkgs/pull/67625#issuecomment-525788428
  PKG_CONFIG_POLKIT_GOBJECT_1_ACTIONDIR = "/run/current-system/sw/share/polkit-1/actions";

  # Phase hooks

  postPatch = ''
    patchShebangs \
      contrib/generate-version-script.py \
      contrib/generate-man.py \
      po/test-deps

    substituteInPlace data/installed-tests/fwupdmgr-p2p.sh \
      --replace "gdbus" ${glib.bin}/bin/gdbus

    # tests fail with: Failed to load SMBIOS: neither SMBIOS or DT found
    sed -i 's/test(.*)//' plugins/lenovo-thinklmi/meson.build
    sed -i 's/test(.*)//' plugins/mtd/meson.build
    # fails on amd cpu
    sed -i 's/test(.*)//' libfwupdplugin/meson.build
    # in nixos test tries to chmod 0777 $out/share/installed-tests/fwupd/tests/redfish.conf
    sed -i "s/get_option('tests')/false/" plugins/redfish/meson.build

    # Device tests use device emulation and need to download emulation data from
    # the internet, which does not work on our test VMs.
    # It's probably better to disable these tests for NixOS by setting
    # the device-tests directory to /dev/null.
    # For more info on device emulation, see:
    #   https://github.com/fwupd/fwupd/blob/eeeac4e9ba8a6513428b456a551bffd95d533e50/docs/device-emulation.md
    substituteInPlace data/installed-tests/meson.build \
      --replace "join_paths(datadir, 'fwupd', 'device-tests')" "'/dev/null'"
  '';

  preBuild = ''
    # jcat-tool at buildtime requires a home directory
    export HOME="$(mktemp -d)"
  '';

  preCheck = ''
    addToSearchPath XDG_DATA_DIRS "${shared-mime-info}/share"

    echo "12345678901234567890123456789012" > machine-id
    export NIX_REDIRECTS=/etc/machine-id=$(realpath machine-id) \
    LD_PRELOAD=${libredirect}/lib/libredirect.so
  '';

  postInstall = ''
    # These files have weird licenses so they are shipped separately.
    cp --recursive --dereference "${test-firmware}/installed-tests/tests" "$installedTests/libexec/installed-tests/fwupd"
  '';

  preFixup =
    let
      binPath = [
        efibootmgr
        bubblewrap
        tpm2-tools
      ];
    in
    ''
      gappsWrapperArgs+=(
        --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
        # See programs reached with fu_common_find_program_in_path in source
        --prefix PATH : "${lib.makeBinPath binPath}"
      )
    '';

  postFixup = ''
    # Since we had to disable wrapGAppsHook, we need to wrap the executables manually.
    find -L "$out/bin" "$out/libexec" -type f -executable -print0 \
      | while IFS= read -r -d ''' file; do
      if [[ "$file" != *.efi ]]; then
        echo "Wrapping program $file"
        wrapGApp "$file"
      fi
    done

    # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
    moveToOutput "share/doc" "$devdoc"
  '';

  separateDebugInfo = true;

  passthru = {
    filesInstalledToEtc = [
      "fwupd/bios-settings.d/README.md"
      "fwupd/fwupd.conf"
      "fwupd/remotes.d/lvfs-testing.conf"
      "fwupd/remotes.d/lvfs.conf"
      "fwupd/remotes.d/vendor.conf"
      "fwupd/remotes.d/vendor-directory.conf"
      "pki/fwupd/GPG-KEY-Linux-Foundation-Firmware"
      "pki/fwupd/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd/LVFS-CA.pem"
      "pki/fwupd-metadata/GPG-KEY-Linux-Foundation-Metadata"
      "pki/fwupd-metadata/GPG-KEY-Linux-Vendor-Firmware-Service"
      "pki/fwupd-metadata/LVFS-CA.pem"
      "grub.d/35_fwupd"
    ] ++ lib.optionals haveDell [
      "fwupd/remotes.d/dell-esrt.conf"
    ];

    # DisabledPlugins key in fwupd/daemon.conf
    defaultDisabledPlugins = [
      "test"
      "test_ble"
    ];

    # For updating.
    inherit test-firmware;

    # For downstream consumers that need the fwupd-efi this was built with.
    inherit fwupd-efi;

    tests =
      let
        listToPy = list: "[${lib.concatMapStringsSep ", " (f: "'${f}'") list}]";
      in
      {
        installedTests = nixosTests.installed-tests.fwupd;

        passthruMatches = runPythonCommand "fwupd-test-passthru-matches" ''
          import itertools
          import configparser
          import os
          import pathlib

          etc = '${finalAttrs.finalPackage}/etc'
          package_etc = set(itertools.chain.from_iterable([[os.path.relpath(os.path.join(prefix, file), etc) for file in files] for (prefix, dirs, files) in os.walk(etc)]))
          passthru_etc = set(${listToPy finalAttrs.passthru.filesInstalledToEtc})
          assert len(package_etc - passthru_etc) == 0, f'fwupd package contains the following paths in /etc that are not listed in passthru.filesInstalledToEtc: {package_etc - passthru_etc}'
          assert len(passthru_etc - package_etc) == 0, f'fwupd package lists the following paths in passthru.filesInstalledToEtc that are not contained in /etc: {passthru_etc - package_etc}'

          config = configparser.RawConfigParser()
          config.read('${finalAttrs.finalPackage}/etc/fwupd/fwupd.conf')
          package_disabled_plugins = config.get('fwupd', 'DisabledPlugins').rstrip(';').split(';')
          passthru_disabled_plugins = ${listToPy finalAttrs.passthru.defaultDisabledPlugins}
          assert package_disabled_plugins == passthru_disabled_plugins, f'Default disabled plug-ins in the package {package_disabled_plugins} do not match those listed in passthru.defaultDisabledPlugins {passthru_disabled_plugins}'

          pathlib.Path(os.getenv('out')).touch()
        '';
      };
  };

  meta = with lib; {
    homepage = "https://fwupd.org/";
    maintainers = with maintainers; [ rvdp ];
    license = licenses.lgpl21Plus;
    platforms = platforms.linux;
  };
})
