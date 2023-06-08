{ lib
, stdenv
, prismlauncher-unwrapped
, runCommandLocal
, wrapQtAppsHook
, makeWrapper
, bubblewrap
, qtbase  # needed for wrapQtAppsHook
, qtsvg
, qtwayland
, xorg
, libpulseaudio
, libGL
, glfw
, openal
, jdk8
, jdk17
, gamemode

, enableBubblewrap ? lib.meta.availableOn stdenv.hostPlatform bubblewrap
, msaClientID ? null
, gamemodeSupport ? false
, jdks ? [ jdk17 jdk8 ]
, additionalLibs ? [ ]
}:
# `gamemodeSupport` requires session D-Bus access, which is blocked by the sandbox.
assert enableBubblewrap -> !gamemodeSupport;

let
  prismlauncherFinal = prismlauncher-unwrapped.override {
    inherit msaClientID gamemodeSupport;
  };

in
runCommandLocal "prismlauncher-${prismlauncherFinal.version}" {
  nativeBuildInputs = [
    wrapQtAppsHook

    # Force to use the shell wrapper instead of the binary wrapper. We have scripts.
    makeWrapper
  ];

  buildInputs = [
    qtbase
    qtsvg
  ]
  ++ lib.optional (lib.versionAtLeast qtbase.version "6") qtwayland;

  # Passthrough
  # Ref: https://github.com/NixOS/nixpkgs/blob/5e871d8aa6f57cc8e0dc087d1c5013f6e212b4ce/pkgs/build-support/build-fhsenv-bubblewrap/default.nix#L170
  wrapperPreExec = lib.optionalString enableBubblewrap ''
    args=()
    if [[ "$DISPLAY" == :* ]]; then
        local_socket="/tmp/.X11-unix/X''${DISPLAY#?}"
        args+=(--ro-bind-try "$local_socket" "$local_socket")
    fi
    if [[ "$WAYLAND_DISPLAY" = /* ]]; then
        args+=(--ro-bind-try "$WAYLAND_DISPLAY" "$WAYLAND_DISPLAY")
    elif [[ -n "$WAYLAND_DISPLAY" ]]; then
        args+=(--ro-bind-try "$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY" "/tmp/$WAYLAND_DISPLAY")
    fi
  '';

  bwrapArgs = lib.optionals enableBubblewrap [
    "--unshare-user"
    "--unshare-ipc"
    "--unshare-pid"
    "--unshare-uts"
    "--unshare-cgroup"
    "--die-with-parent"

    "--dev /dev"
    "--proc /proc"
    "--ro-bind /nix /nix"
    "--ro-bind /etc /etc"
    "--tmpfs /tmp"

    # Network is required.
    "--share-net"
    "--ro-bind /run/systemd/resolve /run/systemd/resolve"

    # Mesa & OpenGL.
    "--ro-bind /run/opengl-driver /run/opengl-driver"
    "--dev-bind-try /dev/dri /dev/dri"
    "--ro-bind-try /sys/class /sys/class"
    "--ro-bind-try /sys/dev/char /sys/dev/char"
    "--ro-bind-try /sys/devices/pci0000:00 /sys/devices/pci0000:00"
    "--ro-bind-try /sys/devices/system/cpu /sys/devices/system/cpu"

    # Audio.
    "--setenv XDG_RUNTIME_DIR /tmp"
    ''--ro-bind-try "$XDG_RUNTIME_DIR/pulse" /tmp/pulse''
    ''--ro-bind-try "$XDG_RUNTIME_DIR/pipewire-0" /tmp/pipewire-0''

    # Runtime args from `wrapperPreExec`.
    ''"''${args[@]}"''

    # Data storage.
    ''--bind "''${XDG_DATA_HOME:-$HOME/.local/share}/PrismLauncher" $HOME/.local/share/PrismLauncher''
    "--unsetenv XDG_DATA_HOME"

    # Block dangerous D-Bus.
    "--unsetenv DBUS_SESSION_BUS_ADDRESS"

    "--"
    "${prismlauncherFinal}/bin/prismlauncher"
  ];

  qtWrapperArgs =
    let
      libs = (with xorg; [
        libX11
        libXext
        libXcursor
        libXrandr
        libXxf86vm
      ])
      ++ [
        libpulseaudio
        libGL
        glfw
        openal
        stdenv.cc.cc.lib
      ]
      ++ lib.optional gamemodeSupport gamemode.lib
      ++ additionalLibs;

    in
    [
      "--set LD_LIBRARY_PATH /run/opengl-driver/lib:${lib.makeLibraryPath libs}"
      "--prefix PRISMLAUNCHER_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}"
      # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      "--prefix PATH : ${lib.makeBinPath [xorg.xrandr]}"
    ];

  inherit (prismlauncherFinal) meta;
} ''
  ${if enableBubblewrap then ''
    qtWrapperArgs+=(--run "$wrapperPreExec" --add-flags "$bwrapArgs")
    makeQtWrapper ${bubblewrap}/bin/bwrap $out/bin/prismlauncher
  '' else ''
    makeQtWrapper ${prismlauncherFinal}/bin/prismlauncher $out/bin/prismlauncher
  ''}
  ln -s ${prismlauncherFinal}/share $out/share
''
