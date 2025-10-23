{
  lib,
  stdenv,
  makeWrapper,
  fetchurl,
  fetchzip,
  wrapGAppsHook3,
  glib,
  gtk3,
  gtk4,
  unzip,
  at-spi2-atk,
  libdrm,
  libgbm,
  libxkbcommon,
  libxshmfence,
  libGL,
  vulkan-loader,
  alsa-lib,
  cairo,
  cups,
  dbus,
  expat,
  gdk-pixbuf,
  nss,
  nspr,
  xorg,
  pango,
  systemd,
  pciutils,
  libnotify,
  pipewire,
  libsecret,
  libpulseaudio,
  speechd-minimal,
}:

version: hashes:
let
  pname = "electron";

  meta = with lib; {
    description = "Cross platform desktop application shell";
    homepage = "https://github.com/electron/electron";
    license = licenses.mit;
    mainProgram = "electron";
    teams = [ teams.electron ];
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
      "armv7l-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    # https://www.electronjs.org/docs/latest/tutorial/electron-timelines
    knownVulnerabilities = optional (versionOlder version "36.0.0") "Electron version ${version} is EOL";
  };

  fetcher =
    vers: tag: hash:
    fetchurl {
      url = "https://github.com/electron/electron/releases/download/v${vers}/electron-v${vers}-${tag}.zip";
      sha256 = hash;
    };

  headersFetcher =
    vers: hash:
    fetchzip {
      name = "electron-${vers}-headers";
      url = "https://artifacts.electronjs.org/headers/dist/v${vers}/node-v${vers}-headers.tar.gz";
      sha256 = hash;
    };

  tags = {
    x86_64-linux = "linux-x64";
    armv7l-linux = "linux-armv7l";
    aarch64-linux = "linux-arm64";
    x86_64-darwin = "darwin-x64";
    aarch64-darwin = "darwin-arm64";
  };

  get = as: platform: as.${platform.system} or (throw "Unsupported system: ${platform.system}");

  common = platform: {
    inherit pname version meta;
    src = fetcher version (get tags platform) (get hashes platform);
    passthru.headers = headersFetcher version hashes.headers;
  };

  electronLibPath = lib.makeLibraryPath [
    alsa-lib
    at-spi2-atk
    cairo
    cups
    dbus
    expat
    gdk-pixbuf
    glib
    gtk3
    gtk4
    nss
    nspr
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXrandr
    xorg.libxkbfile
    pango
    pciutils
    stdenv.cc.cc
    systemd
    libnotify
    pipewire
    libsecret
    libpulseaudio
    speechd-minimal
    libdrm
    libgbm
    libxkbcommon
    libxshmfence
    libGL
    vulkan-loader
  ];

  linux = finalAttrs: {
    buildInputs = [
      glib
      gtk3
      gtk4
    ];

    nativeBuildInputs = [
      unzip
      makeWrapper
      wrapGAppsHook3
    ];

    dontUnpack = true;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/libexec/electron
      unzip -d $out/libexec/electron $src
      chmod u-x $out/libexec/electron/*.so*
    '';

    # We don't want to wrap the contents of $out/libexec automatically
    dontWrapGApps = true;

    preFixup = ''
      makeWrapper "$out/libexec/electron/electron" $out/bin/electron \
        "''${gappsWrapperArgs[@]}"
    '';

    postFixup = ''
      patchelf \
        --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath "${electronLibPath}:$out/libexec/electron" \
        $out/libexec/electron/electron \
        $out/libexec/electron/chrome_crashpad_handler

      # patch libANGLE
      patchelf \
        --set-rpath "${
          lib.makeLibraryPath [
            libGL
            pciutils
            vulkan-loader
          ]
        }" \
        $out/libexec/electron/lib*GL*

      # replace bundled vulkan-loader
      rm "$out/libexec/electron/libvulkan.so.1"
      ln -s -t "$out/libexec/electron" "${lib.getLib vulkan-loader}/lib/libvulkan.so.1"
    '';

    passthru.dist = finalAttrs.finalPackage + "/libexec/electron";
  };

  darwin = finalAttrs: {
    nativeBuildInputs = [
      makeWrapper
      unzip
    ];

    buildCommand = ''
      mkdir -p $out/Applications
      unzip $src
      mv Electron.app $out/Applications
      mkdir -p $out/bin
      makeWrapper $out/Applications/Electron.app/Contents/MacOS/Electron $out/bin/electron
    '';

    passthru.dist = finalAttrs.finalPackage + "/Applications";
  };
in
stdenv.mkDerivation (
  finalAttrs:
  lib.recursiveUpdate (common stdenv.hostPlatform) (
    (if stdenv.hostPlatform.isDarwin then darwin else linux) finalAttrs
  )
)
