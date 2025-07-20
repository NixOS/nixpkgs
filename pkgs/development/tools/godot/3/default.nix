{
  lib,
  stdenv,
  alsa-lib,
  alsa-plugins,
  autoPatchelfHook,
  fetchFromGitHub,
  freetype,
  installShellFiles,
  libGLU,
  libpulseaudio,
  libX11,
  libXcursor,
  libXext,
  libXfixes,
  libXi,
  libXinerama,
  libXrandr,
  libXrender,
  makeWrapper,
  openssl,
  pkg-config,
  scons,
  udev,
  yasm,
  zlib,
}:

stdenv.mkDerivation (self: {
  pname = "godot3";
  version = "3.6";
  godotBuildDescription = "X11 tools";

  src = fetchFromGitHub {
    owner = "godotengine";
    repo = "godot";
    rev = "${self.version}-stable";
    sha256 = "sha256-4WQYO1BBDK9+eyblpI8qRgbBG4+qPRVZMjeAFAtot+0=";
  };

  # Fix PIE hardening: https://github.com/godotengine/godot/pull/50737
  postPatch = ''
    substituteInPlace platform/x11/detect.py \
      --replace-fail 'env.Append(LINKFLAGS=["-no-pie"])' ""
  '';

  nativeBuildInputs = [
    autoPatchelfHook
    installShellFiles
    makeWrapper
    pkg-config
    scons
  ];

  buildInputs = [
    alsa-lib
    freetype
    libGLU
    libpulseaudio
    libX11
    libXcursor
    libXext
    libXfixes
    libXi
    libXinerama
    libXrandr
    libXrender
    openssl
    udev
    yasm
    zlib
  ];

  shouldAddLinkFlagsToPulse = true;

  patches = map (rp: ./patches + rp) [
    # The version of SConstruct in the godot source appends the OS's PATH to the Scons PATH,
    # but because it is an append, the Scons PATH takes precedence.  The Scons PATH contains a
    # bunch of standard Linux paths like /usr/bin, so if they happen to contain versions of any
    # build-time dependencies of Godot, they will be used instead of the Nix version of them.
    #
    # This patch simply replaces the entire Scons environment (including the PATH) with that
    # of the OS. This isn't as surgical as just fixing the PATH, but it seems to work, and
    # seems to be the Nix community's current strategy when using Scons.
    /SConstruct/dontClobberEnvironment.patch
    # Fix compile error with mono 6.14
    # https://github.com/godotengine/godot/pull/106578
    /move-MonoGCHandle-into-gdmono-namespace.patch
  ];

  enableParallelBuilding = true;
  godotBuildPlatform = "x11";
  shouldBuildTools = true;
  godotBuildTarget = "release_debug";

  lto = if self.godotBuildTarget == "release" then "full" else "none";

  sconsFlags = [
    "arch=${stdenv.hostPlatform.linuxArch}"
    "platform=${self.godotBuildPlatform}"
    "tools=${lib.boolToString self.shouldBuildTools}"
    "target=${self.godotBuildTarget}"
    "bits=${toString stdenv.hostPlatform.parsed.cpu.bits}"
    "lto=${self.lto}"
  ];

  shouldWrapBinary = self.shouldBuildTools;
  shouldInstallManual = self.shouldBuildTools;
  shouldPatchBinary = self.shouldBuildTools;
  shouldInstallHeaders = self.shouldBuildTools;
  shouldInstallShortcut = self.shouldBuildTools && self.godotBuildPlatform != "server";

  outputs = [
    "out"
  ]
  ++ lib.optional self.shouldInstallManual "man"
  ++ lib.optional self.shouldBuildTools "dev";

  builtGodotBinNamePattern =
    if self.godotBuildPlatform == "server" then "godot_server.*" else "godot.*";

  godotBinInstallPath = "bin";
  installedGodotBinName = self.pname;
  installedGodotShortcutFileName = "org.godotengine.Godot3.desktop";
  installedGodotShortcutDisplayName = "Godot Engine 3";

  installPhase = ''
    runHook preInstall

    echo "Installing godot binaries."
    outbin="$out/$godotBinInstallPath"
    mkdir -p "$outbin"
    cp -R bin/. "$outbin"
    mv "$outbin"/$builtGodotBinNamePattern "$outbin/$installedGodotBinName"

    if [ -n "$shouldWrapBinary" ]; then
      wrapProgram "$outbin/$installedGodotBinName" \
        --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib
    fi

    if [ -n "$shouldInstallManual" ]; then
      echo "Installing godot manual."
      mansrc=misc/dist/linux
      mv "$mansrc"/godot.6 "$mansrc"/godot3.6
      installManPage "$mansrc"/godot3.6
    fi

    if [ -n "$shouldInstallHeaders" ]; then
      echo "Installing godot headers."
      mkdir -p "$dev"
      cp -R modules/gdnative/include "$dev"
    fi

    if [ -n "$shouldInstallShortcut" ]; then
      echo "Installing godot shortcut."
      mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
      cp misc/dist/linux/org.godotengine.Godot.desktop "$out"/share/applications/$installedGodotShortcutFileName
      cp icon.svg "$out"/share/icons/hicolor/scalable/apps/godot.svg
      cp icon.png "$out"/share/icons/godot.png
      substituteInPlace "$out"/share/applications/$installedGodotShortcutFileName \
        --replace "Exec=godot" "Exec=\"$outbin/$installedGodotBinName\"" \
        --replace "Name=Godot Engine" "Name=$installedGodotShortcutDisplayName"
    fi

    runHook postInstall
  '';

  runtimeDependencies = lib.optionals self.shouldPatchBinary (
    map lib.getLib [
      alsa-lib
      libpulseaudio
      udev
    ]
  );

  meta = with lib; {
    homepage = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine (" + self.godotBuildDescription + ")";
    license = licenses.mit;
    platforms = [
      "i686-linux"
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = with maintainers; [
      rotaerk
      twey
    ];
  };
})
