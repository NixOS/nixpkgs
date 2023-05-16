{ stdenv
, lib
, fetchFromGitHub
, pkg-config
, autoPatchelfHook
, installShellFiles
, scons
, vulkan-loader
, libGL
, libX11
, libXcursor
, libXinerama
, libXext
, libXrandr
, libXrender
, libXi
, libXfixes
, libxkbcommon
, alsa-lib
, libpulseaudio
, dbus
, speechd
, fontconfig
, udev
, withPlatform ? "linuxbsd"
, withTarget ? "editor"
, withPrecision ? "single"
, withPulseaudio ? true
, withDbus ? true
, withSpeechd ? true
, withFontconfig ? true
, withUdev ? true
, withTouch ? true
}:

assert lib.asserts.assertOneOf "withPrecision" withPrecision [ "single" "double" ];

let
<<<<<<< HEAD
  mkSconsFlagsFromAttrSet = lib.mapAttrsToList (k: v:
    if builtins.isString v
    then "${k}=${v}"
    else "${k}=${builtins.toJSON v}");
in
stdenv.mkDerivation rec {
  pname = "godot";
  version = "4.1.1";
  commitHash = "bd6af8e0ea69167dd0627f3bd54f9105bda0f8b5";
=======
  options = {
    # Options from 'godot/SConstruct'
    platform = withPlatform;
    target = withTarget;
    precision = withPrecision; # Floating-point precision level

    # Options from 'godot/platform/linuxbsd/detect.py'
    pulseaudio = withPulseaudio; # Use PulseAudio
    dbus = withDbus; # Use D-Bus to handle screensaver and portal desktop settings
    speechd = withSpeechd; # Use Speech Dispatcher for Text-to-Speech support
    fontconfig = withFontconfig; # Use fontconfig for system fonts support
    udev = withUdev; # Use udev for gamepad connection callbacks
    touch = withTouch; # Enable touch events
  };
in
stdenv.mkDerivation rec {
  pname = "godot";
  version = "4.0.2-stable";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "godotengine";
    repo = "godot";
<<<<<<< HEAD
    rev = commitHash;
    hash = "sha256-0CErsMTrBC/zYcabAtjYn8BWAZ1HxgozKdgiqdsn3q8=";
=======
    rev = version;
    hash = "sha256-kFIpY8kHa8ds/JgYWcUMB4RhwcJDebfeWFnI3BkFWiI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  nativeBuildInputs = [
    pkg-config
    autoPatchelfHook
    installShellFiles
  ];

  buildInputs = [
    scons
  ];

  runtimeDependencies = [
    vulkan-loader
    libGL
    libX11
    libXcursor
    libXinerama
    libXext
    libXrandr
    libXrender
    libXi
    libXfixes
    libxkbcommon
    alsa-lib
  ]
  ++ lib.optional withPulseaudio libpulseaudio
  ++ lib.optional withDbus dbus
  ++ lib.optional withDbus dbus.lib
  ++ lib.optional withSpeechd speechd
  ++ lib.optional withFontconfig fontconfig
  ++ lib.optional withFontconfig fontconfig.lib
  ++ lib.optional withUdev udev;

  enableParallelBuilding = true;

<<<<<<< HEAD
  # Set the build name which is part of the version. In official downloads, this
  # is set to 'official'. When not specified explicitly, it is set to
  # 'custom_build'. Other platforms packaging Godot (Gentoo, Arch, Flatpack
  # etc.) usually set this to their name as well.
  #
  # See also 'methods.py' in the Godot repo and 'build' in
  # https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-get-version-info
  BUILD_NAME = "nixpkgs";

  # Required for the commit hash to be included in the version number.
  #
  # `methods.py` reads the commit hash from `.git/HEAD` and manually follows
  # refs. Since we just write the hash directly, there is no need to emulate any
  # other parts of the .git directory.
  #
  # See also 'hash' in
  # https://docs.godotengine.org/en/stable/classes/class_engine.html#class-engine-method-get-version-info
  preConfigure = ''
    mkdir -p .git
    echo ${commitHash} > .git/HEAD
  '';

  sconsFlags = mkSconsFlagsFromAttrSet {
    # Options from 'SConstruct'
    production = true; # Set defaults to build Godot for use in production
    platform = withPlatform;
    target = withTarget;
    precision = withPrecision; # Floating-point precision level

    # Options from 'platform/linuxbsd/detect.py'
    pulseaudio = withPulseaudio; # Use PulseAudio
    dbus = withDbus; # Use D-Bus to handle screensaver and portal desktop settings
    speechd = withSpeechd; # Use Speech Dispatcher for Text-to-Speech support
    fontconfig = withFontconfig; # Use fontconfig for system fonts support
    udev = withUdev; # Use udev for gamepad connection callbacks
    touch = withTouch; # Enable touch events
  };

=======
  # Options from 'godot/SConstruct' and 'godot/platform/linuxbsd/detect.py'
  sconsFlags = [ "production=true" ];
  preConfigure = ''
    sconsFlags+=" ${
      lib.concatStringsSep " "
      (lib.mapAttrsToList (k: v: "${k}=${builtins.toJSON v}") options)
    }"
  '';

>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  outputs = [ "out" "man" ];

  installPhase = ''
    mkdir -p "$out/bin"
<<<<<<< HEAD
    cp bin/godot.* $out/bin/godot4
=======
    cp bin/godot.* $out/bin/godot
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

    installManPage misc/dist/linux/godot.6

    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
<<<<<<< HEAD
    cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/org.godotengine.Godot4.desktop"
    substituteInPlace "$out/share/applications/org.godotengine.Godot4.desktop" \
      --replace "Exec=godot" "Exec=$out/bin/godot4" \
      --replace "Godot Engine" "Godot Engine 4"
=======
    cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/"
    substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
      --replace "Exec=godot" "Exec=$out/bin/godot"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
    cp icon.png "$out/share/icons/godot.png"
  '';

  meta = with lib; {
    homepage = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" "aarch64-linux" ];
    maintainers = with maintainers; [ twey shiryel ];
<<<<<<< HEAD
    mainProgram = "godot4";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };
}
