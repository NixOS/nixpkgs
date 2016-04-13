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

{ stdenv, lib, fetchurl, pkgconfig, help2man, makeWrapper
, glib, libbsd
, libX11, libXext, xorgserver, xkbcomp, module_init_tools, xkeyboard_config, xf86videonouveau
, nvidia_x11, virtualgl, primusLib
# The below should only be non-null in a x86_64 system. On a i686
# system the above nvidia_x11 and virtualgl will be the i686 packages.
# TODO: Confusing. Perhaps use "SubArch" instead of i686?
, nvidia_x11_i686 ? null
, primusLib_i686 ? null
, useDisplayDevice ? false
, extraNvidiaDeviceOptions ? ""
, extraNouveauDeviceOptions ? ""
, useNvidia ? true
}:

let
  version = "3.2.1";

  primus = if useNvidia then primusLib else primusLib.override { nvidia_x11 = null; };
  primus_i686 = if useNvidia then primusLib_i686 else primusLib_i686.override { nvidia_x11 = null; };

  primusLibs = lib.makeLibraryPath ([primus] ++ lib.optional (primusLib_i686 != null) primus_i686);

  nvidia_x11s = [nvidia_x11] ++ lib.optional (nvidia_x11_i686 != null) nvidia_x11_i686;

  nvidiaLibs = lib.makeLibraryPath nvidia_x11s;

  bbdPath = lib.makeBinPath [ module_init_tools xorgserver ];
  bbdLibs = lib.makeLibraryPath [ libX11 libXext ];

  xmodules = lib.concatStringsSep "," (map (x: "${x}/lib/xorg/modules") ([ xorgserver ] ++ lib.optional (!useNvidia) xf86videonouveau));

in stdenv.mkDerivation rec {
  name = "bumblebee-${version}";

  src = fetchurl {
    url = "http://bumblebee-project.org/${name}.tar.gz";
    sha256 = "03p3gvx99lwlavznrpg9l7jnl1yfg2adcj8jcjj0gxp20wxp060h";
  };

  patches = [ ./nixos.patch ];

  # By default we don't want to use a display device
  nvidiaDeviceOptions = lib.optionalString (!useDisplayDevice) ''
    # Disable display device
    Option "UseEDID" "false"
    Option "UseDisplayDevice" "none"
  '' + extraNvidiaDeviceOptions;

  nouveauDeviceOptions = extraNouveauDeviceOptions;

  # the have() function is deprecated and not available to bash completions the
  # way they are currently loaded in NixOS, so use _have. See #10936
  postPatch = ''
    substituteInPlace scripts/bash_completion/bumblebee \
      --replace "have optirun" "_have optirun"
  '';

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
      --subst-var nvidiaDeviceOptions

    substituteInPlace conf/xorg.conf.nouveau \
      --subst-var nouveauDeviceOptions
  '';

  # Build-time dependencies of bumblebeed and optirun.
  # Note that it has several runtime dependencies.
  buildInputs = [ libX11 glib libbsd ];
  nativeBuildInputs = [ makeWrapper pkgconfig help2man ];

  # The order of LDPATH is very specific: First X11 then the host
  # environment then the optional sub architecture paths.
  #
  # The order for MODPATH is the opposite: First the environment that
  # includes the acceleration driver. As this is used for the X11
  # server, which runs under the host architecture, this does not
  # include the sub architecture components.
  configureFlags = [
    "--with-udev-rules=$out/lib/udev/rules.d"
    # see #10282
    #"CONF_PRIMUS_LD_PATH=${primusLibs}"
  ] ++ lib.optionals useNvidia [
    "CONF_LDPATH_NVIDIA=${nvidiaLibs}"
    "CONF_MODPATH_NVIDIA=${nvidia_x11}/lib/xorg/modules"
  ];

  CFLAGS = [
    "-DX_MODULE_APPENDS=\\\"${xmodules}\\\""
    "-DX_XKB_DIR=\\\"${xkeyboard_config}/etc/X11/xkb\\\""
  ];

  postInstall = ''
    wrapProgram "$out/sbin/bumblebeed" \
      --set XKB_BINDIR "${xkbcomp}/bin" \
      --prefix PATH : "${bbdPath}" \
      --prefix LD_LIBRARY_PATH : "${bbdLibs}"

    wrapProgram "$out/bin/optirun" \
      --prefix PATH : "${virtualgl}/bin"
  '';

  meta = with stdenv.lib; {
    homepage = http://github.com/Bumblebee-Project/Bumblebee;
    description = "Daemon for managing Optimus videocards (power-on/off, spawns xservers)";
    platforms = platforms.linux;
    license = licenses.gpl3;
    maintainers = with maintainers; [ abbradar ];
  };
}
