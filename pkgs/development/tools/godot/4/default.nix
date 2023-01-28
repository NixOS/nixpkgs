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
  version = "4.0-beta16";

  src = fetchFromGitHub {
    owner = "godotengine";
    repo = "godot";
    rev = "518b9e5801a19229805fe837d7d0cf92920ad413";
    sha256 = "sha256-45x4moHOn/PWRazuJ/CBb3WYaPZqv4Sn8ZIugUSaVjY=";
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

  # Options from 'godot/SConstruct' and 'godot/platform/linuxbsd/detect.py'
  sconsFlags = [ "production=true" ];
  preConfigure = ''
    sconsFlags+=" ${
      lib.concatStringsSep " "
      (lib.mapAttrsToList (k: v: "${k}=${builtins.toJSON v}") options)
    }"
  '';

  outputs = [ "out" "man" ];

  installPhase = ''
    mkdir -p "$out/bin"
    cp bin/godot.* $out/bin/godot

    installManPage misc/dist/linux/godot.6

    mkdir -p "$out"/share/{applications,icons/hicolor/scalable/apps}
    cp misc/dist/linux/org.godotengine.Godot.desktop "$out/share/applications/"
    substituteInPlace "$out/share/applications/org.godotengine.Godot.desktop" \
      --replace "Exec=godot" "Exec=$out/bin/godot"
    cp icon.svg "$out/share/icons/hicolor/scalable/apps/godot.svg"
    cp icon.png "$out/share/icons/godot.png"
  '';

  meta = with lib; {
    homepage = "https://godotengine.org";
    description = "Free and Open Source 2D and 3D game engine";
    license = licenses.mit;
    platforms = [ "i686-linux" "x86_64-linux" ];
    maintainers = with maintainers; [ twey shiryel ];
  };
}
