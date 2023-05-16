<<<<<<< HEAD
{ lib
, stdenv
, alsa-lib
, alsa-plugins
, autoPatchelfHook
, fetchFromGitHub
, freetype
, installShellFiles
, libGLU
, libpulseaudio
, libX11
, libXcursor
, libXext
, libXfixes
, libXi
, libXinerama
, libXrandr
, libXrender
, makeWrapper
, openssl
, pkg-config
, scons
, udev
, yasm
, zlib
}:

stdenv.mkDerivation (self: {
  pname = "godot3";
  version = "3.5.2";
  godotBuildDescription = "X11 tools";
=======
{ stdenv
, lib
, fetchFromGitHub
, scons
, pkg-config
, udev
, libX11
, libXcursor
, libXinerama
, libXrandr
, libXrender
, libpulseaudio
, libXi
, libXext
, libXfixes
, freetype
, openssl
, alsa-lib
, alsa-plugins
, makeWrapper
, libGLU
, zlib
, yasm
, withUdev ? true
}:

let
  options = {
    touch = libXi != null;
    pulseaudio = false;
    udev = withUdev;
  };
in
stdenv.mkDerivation rec {
  pname = "godot";
  version = "3.5.1";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "godotengine";
    repo = "godot";
<<<<<<< HEAD
    rev = "${self.version}-stable";
    sha256 = "sha256-C+1J5N0ETL1qKust+2xP9uB4x9NwrMqIm8aFAivVYQw=";
  };

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
  ];

  enableParallelBuilding = true;
  godotBuildPlatform = "x11";
  shouldBuildTools = true;
  godotBuildTarget = "release_debug";

  shouldUseLinkTimeOptimization = self.godotBuildTarget == "release";

  sconsFlags = [
    "arch=${stdenv.hostPlatform.linuxArch}"
    "platform=${self.godotBuildPlatform}"
    "tools=${lib.boolToString self.shouldBuildTools}"
    "target=${self.godotBuildTarget}"
    "bits=${toString stdenv.hostPlatform.parsed.cpu.bits}"
    "use_lto=${lib.boolToString self.shouldUseLinkTimeOptimization}"
  ];

  shouldWrapBinary = self.shouldBuildTools;
  shouldInstallManual = self.shouldBuildTools;
  shouldPatchBinary = self.shouldBuildTools;
  shouldInstallHeaders = self.shouldBuildTools;
  shouldInstallShortcut = self.shouldBuildTools && self.godotBuildPlatform != "server";

  outputs = ["out"] ++ lib.optional self.shouldInstallManual "man" ++ lib.optional self.shouldBuildTools "dev";

  builtGodotBinNamePattern = if self.godotBuildPlatform == "server" then "godot_server.*" else "godot.*";

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

  runtimeDependencies = lib.optionals self.shouldPatchBinary (map lib.getLib [
    alsa-lib
    libpulseaudio
    udev
  ]);

  meta = with lib; {
    homepage = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine (" + self.godotBuildDescription + ")";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ rotaerk twey ];
  };
})
=======
    rev = "${version}-stable";
    sha256 = "sha256-uHwTthyhfeQN0R1XjqZ+kGRa5WcpeQzA/DO9hZk4lvU=";
  };

  nativeBuildInputs = [ pkg-config makeWrapper ];
  buildInputs = [
    scons
    udev
    libX11
    libXcursor
    libXinerama
    libXrandr
    libXrender
    libXi
    libXext
    libXfixes
    freetype
    openssl
    alsa-lib
    libpulseaudio
    libGLU
    zlib
    yasm
  ];

  patches = [ ./pkg_config_additions.patch ./dont_clobber_environment.patch ];

  enableParallelBuilding = true;

  sconsFlags = [ "target=release_debug" "platform=x11" ];
  preConfigure = ''
    sconsFlags+=" ${
      lib.concatStringsSep " "
      (lib.mapAttrsToList (k: v: "${k}=${builtins.toJSON v}") options)
    }"
  '';

  outputs = [ "out" "dev" "man" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/godot.* $out/bin/godot

    wrapProgram "$out/bin/godot" \
      --set ALSA_PLUGIN_DIR ${alsa-plugins}/lib/alsa-lib

    mkdir "$dev"
    cp -r modules/gdnative/include $dev

    mkdir -p "$man/share/man/man6"
    cp misc/dist/linux/godot.6 "$man/share/man/man6/"

    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
    cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/"
    cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
    cp icon.png "$out/share/icons/godot.png"
    substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
      --replace "Exec=godot" "Exec=$out/bin/godot"
  '';

  meta = with lib; {
    homepage = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ twey ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
