# The bumblebee package allows a program to be rendered on an
# dedicated video card by spawning an additional X11 server
# and streaming the results via VirtualGL to the primary server.

# The package is rather chaotic; it's also quite recent.
# As it may change a lot, some of the hacks in this nix expression
# will hopefully not be needed in the future anymore.

# To test: make sure that the 'bbswitch' kernel module is installed,
# then run 'bumblebeed' as root and 'optirun glxgears' as user.
# To use at startup, see hardware.bumblebee options.

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
  version = "3.2.1";
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

in stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://bumblebee-project.org/${name}.tar.gz";
    sha256 = "03p3gvx99lwlavznrpg9l7jnl1yfg2adcj8jcjj0gxp20wxp060h";
  };

  patches = [ ./xopts.patch ];

  preConfigure = ''
    # Substitute the path to the actual modinfo program in module.c.
    # Note: module.c also calls rmmod and modprobe, but those just have to
    # be in PATH, and thus no action for them is required.
    substituteInPlace src/module.c \
      --replace "/sbin/modinfo" "${module_init_tools}/sbin/modinfo"

    # Don't use a special group, just reuse wheel.
    substituteInPlace configure \
      --replace 'CONF_GID="bumblebee"' 'CONF_GID="wheel"'
  '';

  # Build-time dependencies of bumblebeed and optirun.
  # Note that it has several runtime dependencies.
  buildInputs = [ stdenv makeWrapper pkgconfig help2man libX11 glib libbsd ];

  configureFlags = [
    "--with-udev-rules=$out/lib/udev/rules.d"
    "CONF_DRIVER=nvidia"
    "CONF_DRIVER_MODULE_NVIDIA=nvidia"
    "CONF_LDPATH_NVIDIA=${commonEnv}/lib"
    "CONF_MODPATH_NVIDIA=${commonEnv}/lib/xorg/modules"
  ];

  # create a wrapper environment for bumblebeed and optirun
  postInstall = ''
    wrapProgram "$out/sbin/bumblebeed" \
      --prefix PATH : "${commonEnv}/sbin:${commonEnv}/bin:\$PATH" \
      --prefix LD_LIBRARY_PATH : "${commonEnv}/lib:\$LD_LIBRARY_PATH" \
      --set FONTCONFIG_FILE "/etc/fonts/fonts.conf" \
      --set XKB_BINDIR "${xorg.xkbcomp}/bin" \
      --set XKB_DIR "${xkeyboard_config}/etc/X11/xkb"

    wrapProgram "$out/bin/optirun" \
      --prefix PATH : "${commonEnv}/sbin:${commonEnv}/bin" \
      --prefix LD_LIBRARY_PATH : "${commonEnv}/lib" \
  '';

  meta = {
    homepage = http://github.com/Bumblebee-Project/Bumblebee;
    description = "Daemon for managing Optimus videocards (power-on/off, spawns xservers)";
    license = stdenv.lib.licenses.gpl3;
  };
}
