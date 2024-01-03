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
, gamemode
, flite
, mesa-demos
, pciutils
, udev
, libusb1

, msaClientID ? null
, gamemodeSupport ? stdenv.isLinux
, textToSpeechSupport ? stdenv.isLinux
, controllerSupport ? stdenv.isLinux

# The flag `withWaylandGLFW` enables runtime-checking of `WAYLAND_DISPLAY`;
# if the option is enabled, a patched version of GLFW will be added to
# `LD_LIBRARY_PATH` so that the launcher can use the correct one
# depending on the desktop environment used.
, withWaylandGLFW ? false

, jdks ? [ jdk17 jdk8 ]
, additionalLibs ? [ ]
, additionalPrograms ? [ ]
}:

assert lib.assertMsg (withWaylandGLFW -> stdenv.isLinux) "withWaylandGLFW is only available on Linux";

let
  # By default, this package uses a binary wrapper for `wrapQtAppsHook`.
  # Enabling `shellWrapper` will add `makeWrapper` to `nativeBuildInputs`,
  # causing `wrapQtAppsHook` to output a shell wrapper instead.
  # This is needed for checking environment variables at runtime
  # and modifying others if necessary (see above option for example).
  # Warning: This can make the program start slower, by about four milliseconds.
  shellWrapper = withWaylandGLFW;

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
  ++ lib.optional shellWrapper makeWrapper;

  buildInputs = [
    qtbase
    qtsvg
  ]
  ++ lib.optional (lib.versionAtLeast qtbase.version "6" && stdenv.isLinux) qtwayland;

  waylandPreExec = ''
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

        # oshi
        udev
      ]
      ++ lib.optional gamemodeSupport gamemode.lib
      ++ lib.optional textToSpeechSupport flite
      ++ lib.optional controllerSupport libusb1
      ++ additionalLibs;

      runtimePrograms = [
        xorg.xrandr
        mesa-demos # need glxinfo
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
