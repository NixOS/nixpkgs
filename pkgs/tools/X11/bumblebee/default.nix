# The bumblebee package allows a program to be rendered on an
# dedicated video card by spawning an additional X11 server and
# streaming the results via VirtualGL or primus to the primary server.

# The package is rather chaotic; it's also quite recent.
# As it may change a lot, some of the hacks in this nix expression
# will hopefully not be needed in the future anymore.

# To test:
# 1. make sure that the 'bbswitch' kernel module is installed,
# 2. then run 'bumblebeed' as root
# 3. Then either 'optirun glxinfo' or 'primusrun glxinfo' as user.
#
# The glxinfo output should indicate the NVidia driver is being used
# and all expected extensions are supported.
#
# To use at startup, see hardware.bumblebee options.

# This nix expression supports for now only the native nvidia driver.
# It should not be hard to generalize this approach to support the
# nouveau driver as well (parameterize hostEnv, i686Env over the
# module package, and parameterize the two wrappers as well)

{ stdenv, fetchurl, pkgconfig, help2man
, libX11, glibc, glib, libbsd
, makeWrapper, buildEnv, module_init_tools
, xorg, xkeyboard_config
, nvidia_x11, virtualgl
# The below should only be non-null in a x86_64 system. On a i686
# system the above nvidia_x11 and virtualgl will be the i686 packages.
# TODO: Confusing. Perhaps use "SubArch" instead of i686?
, nvidia_x11_i686 ? null
, virtualgl_i686 ? null
, useDisplayDevice ? false
, extraDeviceOptions ? ""
}:
with stdenv.lib;
let
  version = "3.2.1";
  name = "bumblebee-${version}";

  # Isolated X11 environment without the acceleration driver module.
  # Includes the rest of the components needed for bumblebeed and
  # optirun to spawn the second X server and to connect to it.
  x11Env = buildEnv {
    name = "bumblebee-env";
    paths = [
      module_init_tools
      xorg.xorgserver
      xorg.xrandr
      xorg.xrdb
      xorg.setxkbmap
      xorg.libX11
      xorg.libXext
      xorg.xf86inputevdev
    ];
  };

  # The environment for the host architecture.
  hostEnv = buildEnv {
    name = "bumblebee-x64-env";
    paths = [
      nvidia_x11
      virtualgl
    ];
  };

  # The environment for the sub architecture, i686, if there is one
  i686Env = if virtualgl_i686 != null
    then buildEnv {
      name = "bumblebee-i686-env";
      paths = [
       nvidia_x11_i686
       virtualgl_i686
      ];
    }
    else null;

  allEnvs = [hostEnv] ++ optional (i686Env != null) i686Env;
  ldPathString = makeLibraryPath allEnvs;

  # By default we don't want to use a display device
  deviceOptions = if useDisplayDevice
                  then ""
                  else ''

                         #   Disable display device
                             Option "UseEDID" "false"
                             Option "UseDisplayDevice" "none"
                       ''
                  + extraDeviceOptions;

in stdenv.mkDerivation {
  inherit name deviceOptions;

  src = fetchurl {
    url = "http://bumblebee-project.org/${name}.tar.gz";
    sha256 = "03p3gvx99lwlavznrpg9l7jnl1yfg2adcj8jcjj0gxp20wxp060h";
  };

  patches = [ ./xopts.patch ./nvidia-conf.patch];

  preConfigure = ''
    # Substitute the path to the actual modinfo program in module.c.
    # Note: module.c also calls rmmod and modprobe, but those just have to
    # be in PATH, and thus no action for them is required.

    substituteInPlace src/module.c \
      --replace "/sbin/modinfo" "${module_init_tools}/sbin/modinfo"

    # Don't use a special group, just reuse wheel.
    substituteInPlace configure \
      --replace 'CONF_GID="bumblebee"' 'CONF_GID="wheel"'

    # Apply configuration options
    substituteInPlace conf/xorg.conf.nvidia \
      --subst-var deviceOptions
  '';

  # Build-time dependencies of bumblebeed and optirun.
  # Note that it has several runtime dependencies.
  buildInputs = [ stdenv makeWrapper pkgconfig help2man libX11 glib libbsd ];

  # The order of LDPATH is very specific: First X11 then the host
  # environment then the optional sub architecture paths.
  #
  # The order for MODPATH is the opposite: First the environment that
  # includes the acceleration driver. As this is used for the X11
  # server, which runs under the host architecture, this does not
  # include the sub architecture components.
  configureFlags = [
    "--with-udev-rules=$out/lib/udev/rules.d"
    "CONF_DRIVER=nvidia"
    "CONF_DRIVER_MODULE_NVIDIA=nvidia"
    "CONF_LDPATH_NVIDIA=${x11Env}/lib:${ldPathString}"
    "CONF_MODPATH_NVIDIA=${hostEnv}/lib/xorg/modules,${x11Env}/lib/xorg/modules"
  ];

  # create a wrapper environment for bumblebeed and optirun
  postInstall = ''
    wrapProgram "$out/sbin/bumblebeed" \
      --prefix PATH : "${x11Env}/sbin:${x11Env}/bin:${hostEnv}/bin:\$PATH" \
      --prefix LD_LIBRARY_PATH : "${x11Env}/lib:${hostEnv}/lib:\$LD_LIBRARY_PATH" \
      --set FONTCONFIG_FILE "/etc/fonts/fonts.conf" \
      --set XKB_BINDIR "${xorg.xkbcomp}/bin" \
      --set XKB_DIR "${xkeyboard_config}/etc/X11/xkb"

    wrapProgram "$out/bin/optirun" \
      --prefix PATH : "${hostEnv}/bin"
  '' + (if i686Env == null
    then ""
    else ''
    makeWrapper "$out/bin/.optirun-wrapped" "$out/bin/optirun32" \
      --prefix PATH : "${i686Env}/bin"
  '');

  meta = {
    homepage = http://github.com/Bumblebee-Project/Bumblebee;
    description = "Daemon for managing Optimus videocards (power-on/off, spawns xservers)";
    license = stdenv.lib.licenses.gpl3;
  };
}
