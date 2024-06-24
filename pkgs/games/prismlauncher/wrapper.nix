{ lib
, stdenv
, symlinkJoin
, makeWrapper
, wrapQtAppsHook
, addOpenGLRunpath

, prismlauncher-unwrapped

, qtbase  # needed for wrapQtAppsHook
, qtsvg
, qtwayland
, xorg
, libpulseaudio
, libGL
, glfw
, glfw-wayland-minecraft
, openal
, jdk8
, jdk17
, jdk21
, gamemode
, flite
, glxinfo
, pciutils
, udev
, vulkan-loader
, libusb1

, msaClientID ? null
, gamemodeSupport ? stdenv.isLinux
, textToSpeechSupport ? stdenv.isLinux
, controllerSupport ? stdenv.isLinux

  # Adds `glfw-wayland-minecraft` to `LD_LIBRARY_PATH`
  # when launched on wayland, allowing for the game to be run natively.
  # Make sure to enable "Use system installation of GLFW" in instance settings
  # for this to take effect
  #
  # Warning: This build of glfw may be unstable, and the launcher
  # itself can take slightly longer to start
, withWaylandGLFW ? false

, jdks ? [ jdk21 jdk17 jdk8 ]
, additionalLibs ? [ ]
, additionalPrograms ? [ ]
}:

assert lib.assertMsg (withWaylandGLFW -> stdenv.isLinux) "withWaylandGLFW is only available on Linux";

let
  prismlauncher' = prismlauncher-unwrapped.override {
    inherit msaClientID gamemodeSupport;
  };
in

symlinkJoin {
  name = "prismlauncher-${prismlauncher'.version}";

  paths = [ prismlauncher' ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ]
  # purposefully using a shell wrapper here for variable expansion
  # see https://github.com/NixOS/nixpkgs/issues/172583
  ++ lib.optional withWaylandGLFW makeWrapper;

  buildInputs = [
    qtbase
    qtsvg
  ]
  ++ lib.optional (lib.versionAtLeast qtbase.version "6" && stdenv.isLinux) qtwayland;

  waylandPreExec = lib.optionalString withWaylandGLFW ''
    if [ -n "$WAYLAND_DISPLAY" ]; then
      export LD_LIBRARY_PATH=${lib.getLib glfw-wayland-minecraft}/lib:"$LD_LIBRARY_PATH"
    fi
  '';

  postBuild = ''
    ${lib.optionalString withWaylandGLFW ''
      qtWrapperArgs+=(--run "$waylandPreExec")
    ''}

    wrapQtAppsHook
  '';

  qtWrapperArgs =
    let
      runtimeLibs = [
        xorg.libX11
        xorg.libXext
        xorg.libXcursor
        xorg.libXrandr
        xorg.libXxf86vm

        # lwjgl
        libpulseaudio
        libGL
        glfw
        openal
        stdenv.cc.cc.lib
        vulkan-loader # VulkanMod's lwjgl

        # oshi
        udev
      ]
      ++ lib.optional gamemodeSupport gamemode.lib
      ++ lib.optional textToSpeechSupport flite
      ++ lib.optional controllerSupport libusb1
      ++ additionalLibs;

      runtimePrograms = [
        xorg.xrandr
        glxinfo
        pciutils # need lspci
      ]
      ++ additionalPrograms;

    in
    [ "--prefix PRISMLAUNCHER_JAVA_PATHS : ${lib.makeSearchPath "bin/java" jdks}" ]
    ++ lib.optionals stdenv.isLinux [
      "--set LD_LIBRARY_PATH ${addOpenGLRunpath.driverLink}/lib:${lib.makeLibraryPath runtimeLibs}"
      # xorg.xrandr needed for LWJGL [2.9.2, 3) https://github.com/LWJGL/lwjgl/issues/128
      "--prefix PATH : ${lib.makeBinPath runtimePrograms}"
    ];

  inherit (prismlauncher') meta;
}
