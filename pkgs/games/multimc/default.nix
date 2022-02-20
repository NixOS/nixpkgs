{ lib, stdenv, bash
, jdk17, jre8
, buildFHSUserEnv
# `extraJVMs` allows the user to specify additional JVMs to be made available
# in `/opt/jvms`. This is a path MultiMC searches for Java installs, so these
# will all be presented in the Java "auto-detect" list in MultiMC.
# Keys in this attribute set will be used to generate the paths for each Java
# install.
, extraJVMs ? {}
# It's possible for certain mods to depend on some native libraries. This
# option allows the user to add additional libraries to the FHS environment so
# these mods will work properly.
, extraPkgs ? []
}:
let
multimc = stdenv.mkDerivation rec {
  name = "multimc-bin";

  src = ./.;

  installPhase = ''
    install -Dm755 $src/run.sh $out/bin/multimc

    mkdir -p $out/share/pixmaps
    install -Dm644 $src/icon.svg $out/share/pixmaps/multimc.svg
    install -Dm755 $src/multimc.desktop $out/share/applications/multimc.desktop
  '';

  meta = with lib; {
    description = "Free, open source launcher and instance manager for Minecraft";
    platforms = [ "x86_64-linux" "i686-linux" ];
    license = licenses.mspl;
    maintainers = with maintainers; [ forkk ];
  };
};

# List of JDKs to smylink inside the path where MultiMC looks for JVMs.
jvms = {
  jre8 = jre8;
  jre17 = jdk17;
} // extraJVMs;

# Path we expect MultiMC to search for Java installs.
javaSymlinkPath = "opt/jdks";

# This takes the JVM packages and symlinks them inside the `javaSymlinkPath` in
# the FHS env.
#
# Different versions of minecraft now depend on different Java versions, and
# MultiMC allows users to have a different Java binary associated with
# different installs of the game.
#
# For this reason, we take the JVMs this package supports and put each one in a
# folder inside `/opt/jdks`. This is one of the paths MultiMC searches for
# JVMs, so it should detect these automatically and allow the user to select
# one.
#
# This works better than pointing MultiMC at a JVM inside the nix store, as
# doing that may result in said JVM disappearing when the user collects
# garbage.
jvmSymlinks = stdenv.mkDerivation rec {
  name = "multimc-jvm-symlinks";
  src = null;
  dontUnpack = true;
  installPhase = let
    jvmInstallCmds = builtins.attrValues (builtins.mapAttrs (name: value:
      "cp -rsHf ${value} $out/${javaSymlinkPath}/${name}"
    ) jvms);
  in ''
    mkdir -p $out/${javaSymlinkPath}
  '' + (builtins.concatStringsSep "\n" jvmInstallCmds);
};
in
buildFHSUserEnv {
  name = "multimc-bin";
  targetPkgs = pkgs: with pkgs; with xorg; [
    # MultiMC and direct dependencies.
    multimc qt5.full zlib
    # Tools used by the start scripts.
    wget gnused gnutar gnome.zenity
    # Base libraries the game needs.
    libX11 libXext libXcursor libXrandr libXxf86vm libpulseaudio libGL
    glfw openal # Needed for the "use native glfw/openal" settings
    # Symlink JVMs in `/usr/lib/java`
    jvmSymlinks
  ] ++ extraPkgs;

  extraOutputsToInstall = ["${javaSymlinkPath}"];
  extraInstallCommands = ''
    mkdir -p $out/share/pixmaps
    install -Dm644 ${multimc.src}/icon.svg $out/share/pixmaps/multimc.svg
    install -Dm755 ${multimc.src}/multimc.desktop $out/share/applications/multimc.desktop
  '';
  runScript = "multimc";

  meta = multimc.meta;
}
