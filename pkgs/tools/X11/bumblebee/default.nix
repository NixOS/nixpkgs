# The bumblebee package allows a program to be rendered on an
# dedicated video card by spawning an additional X11 server
# and streaming the results via VirtualGL to the primary server.

# The package is rather chaotic; it's also quite recent.
# As it may change a lot, some of the hacks in this nix expression
# will hopefully not be needed in the future anymore.

# To test: make sure that the 'bbswitch' kernel module is installed,
# then run 'bumblebeed' as root and 'optirun glxgears' as user.
# To use at startup, add e.g. to configuration.nix:
# jobs = {
#   bumblebeed = {
#     name = "bumblebeed";
#     description = "Manages the Optimus video card";
#     startOn = "started udev and started syslogd";
#     stopOn = "starting shutdown";
#     exec = "bumblebeed --use-syslog";
#     path = [ pkgs.bumblebee ];
#     environment = { MODULE_DIR = "${config.system.modulesTree}/lib/modules"; };
#     respawn = true;
#   };
# };

# This nix expression supports for now only the native nvidia driver.
# It should not be hard to generalize this approach to support the
# nouveau driver as well (parameterize commonEnv over the module
# package, and parameterize the two wrappers as well)

{ stdenv, fetchurl, pkgconfig, help2man
, libX11, glibc, glib, libbsd
, makeWrapper, buildEnv, module_init_tools
, linuxPackages, virtualgl, xorg, xkeyboard_config
}:

let
  version = "3.0";
  name = "bumblebee-${version}";

  # isolated X11 environment with the nvidia module
  # it should include all components needed for bumblebeed and
  # optirun to spawn the second X server and to connect to it.
  commonEnv = buildEnv {
    name = "bumblebee-env";
    paths = [
      module_init_tools

      linuxPackages.nvidia_x11
      xorg.xorgserver
      xorg.xrandr
      xorg.xrdb
      xorg.setxkbmap
      xorg.libX11
      xorg.libXext

      virtualgl
    ];

    # the nvidia GLX module overwrites the one of xorgserver,
    # thus nvidia_x11 must be before xorgserver in the paths.
    ignoreCollisions = true;
  };

  # Custom X11 configuration for the additional xserver instance.
  xorgConf = ./xorg.conf.nvidia;

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://github.com/downloads/Bumblebee-Project/Bumblebee/${name}.tar.gz";
    sha256 = "a27ddb77b282ac8b972857fdb0dc5061cf0a0982b7ac3e1cfa698b4f786e49a1";
  };

  # 'config.patch' makes bumblebee read the active module and the nvidia configuration
  # from the environment variables instead of the config file:
  #   BUMBLEBEE_DRIVER, BUMBLEBEE_LDPATH_NVIDIA, BUMBLEBEE_MODPATH_NVIDIA
  # These variables must be set when bumblebeed and optirun are executed.
  patches = [ ./config.patch ./xopts.patch ];

  preConfigure = ''
    # Substitute the path to the actual modinfo program in module.c.
    # Note: module.c also calls rmmod and modprobe, but those just have to
    # be in PATH, and thus no action for them is required.
    substituteInPlace src/module.c \
      --replace "/sbin/modinfo" "${module_init_tools}/sbin/modinfo"

    # Don't use a special group, just reuse wheel.
    substituteInPlace configure \
      --replace 'CONF_GID="bumblebee"' 'CONF_GID="wheel"'

    # Ensures that the config file ends up with a nonempty
    # name of the nvidia module. This is needed, because the
    # configuration handling code otherwise resets the
    # data that we obtained from the environment (see config.patch)
    export CONF_DRIVER_MODULE_NVIDIA=nvidia
  '';

  # Build-time dependencies of bumblebeed and optirun.
  # Note that it has several runtime dependencies.
  buildInputs = [ stdenv makeWrapper pkgconfig help2man libX11 glib libbsd ];

  # create a wrapper environment for bumblebeed and optirun
  postInstall = ''
    # remove some entries from the configuration file that would otherwise
    # cause our environment variables to be ignored.
    substituteInPlace "$out/etc/bumblebee/bumblebee.conf" \
      --replace "LibraryPath=" "" \
      --replace "XorgModulePath=" ""

    wrapProgram "$out/sbin/bumblebeed" \
      --prefix PATH : "${commonEnv}/sbin:${commonEnv}/bin:\$PATH" \
      --prefix LD_LIBRARY_PATH : "${commonEnv}/lib:\$LD_LIBRARY_PATH" \
      --set BUMBLEBEE_DRIVER "nvidia" \
      --set BUMBLEBEE_LDPATH_NVIDIA "${commonEnv}/lib" \
      --set BUMBLEBEE_MODPATH_NVIDIA "${commonEnv}/lib/xorg/modules" \
      --set FONTCONFIG_FILE "/etc/fonts/fonts.conf" \
      --set XKB_BINDIR "${xorg.xkbcomp}/bin" \
      --set XKB_DIR "${xkeyboard_config}/etc/X11/xkb"

    wrapProgram "$out/bin/optirun" \
      --prefix PATH : "${commonEnv}/sbin:${commonEnv}/bin" \
      --prefix LD_LIBRARY_PATH : "${commonEnv}/lib" \
      --set BUMBLEBEE_DRIVER "nvidia" \
      --set BUMBLEBEE_LDPATH_NVIDIA "${commonEnv}/lib" \
      --set BUMBLEBEE_MODPATH_NVIDIA "${commonEnv}/lib/xorg/modules"

    cp ${xorgConf} "$out/etc/bumblebee/xorg.conf.nvidia"
  '';

  meta = {
    homepage = http://github.com/Bumblebee-Project/Bumblebee;
    description = "Daemon for managing Optimus videocards (power-on/off, spawns xservers)";
    license = "free";
  };
}
