{ stdenv, fetchurl, cmake, dbus, glib, libcanberra, atk, cairo
, gdk_pixbuf, gtk2, pango, libnotify, libgudev, xorg, sqlite
, gegl, dbus_glib, gettext, pkgconfig, shadow, devices ? false
}:

# Use a semi-colon separated list to specify devices in configuration.nix eg -
# nixpkgs.config.roccat-tools.devices = "konepuremilitary;kiro";
# Supported devices are : arvo;isku;iskufx;koneplus;konepure;konepuremilitary
# ;konepureoptical;konextd;konextdoptical;kovaplus;lua;nyth;pyra;ryosmk;ryostkl;savu
# ;tyon;kone;kiro;kova2016
# By default all devices are built.

stdenv.mkDerivation rec {
  version = "3.9.0";
  name = "roccat-tools-${version}";
  src = fetchurl {
    url = "mirror://sourceforge/libgaminggear/libgaminggear-0.11.2.tar.bz2";
    sha256 = "99abcb627242aa96b597ed831fd1e6df1e8a3958fbaf6cc8e8fdf04d62570d0e";
  };

  toolsSrc = fetchurl {
    url = "mirror://sourceforge/roccat/${name}.tar.bz2";
    sha256 = "ea90b53cf4707c76a41d0f67711eca91e21ef41be253ab45b113a55ac1f278c1";
  };

  dontUseCmakeBuildDir=true;

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [ stdenv cmake dbus glib libcanberra atk cairo gdk_pixbuf 
		  gtk2 pango libnotify libgudev xorg.libX11 
		  xorg.libpthreadstubs xorg.libXdmcp 
		  xorg.libxshmfence sqlite gegl 
		  dbus_glib gettext pkgconfig shadow ];

  config1 = [
    "-DINSTALL_LIBDIR=lib"
    "-DINSTALL_CMAKE_MODULESDIR=usr/share/cmake/Modules"
    "-DINSTALL_PKGCONFIGDIR=usr/share/pkgconfig"
    "-DWITH_UHID=TRUE"
    "-DWITH_DOC=FALSE"
    "-DGFX_PLUGIN_DIR=lib/gaminggear_plugins"
    "-DCMAKE_MODULE_PATH=usr/share/cmake/Modules"
  ];

  config2 = if builtins.isString (devices) then [
    "-DDEVICES=${devices}"
  ] else [
    ""
  ];

  # We build both libgaminggear and roccat-tools in one derivation
  # because roccat-tools writes into libgaminggear's plugin directory.

  builder = builtins.toFile "builder.sh"
    ''
	export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:$out/usr/share/pkgconfig"
	# Build libgaminggear.
	(
	    source $stdenv/setup
	    cmakeFlags=$config1
	    postInstall () {
		mkdir -p "$out/etc/udev/rules.d/"
		mkdir -p "$out/etc/modules-load.d/"
		echo "KERNEL==\"uhid\", GROUP=\"roccat\", MODE=\"0660\"" > $out/etc/udev/rules.d/55-uinput.rules
		echo "uhid" > $out/etc/modules-load.d/uinput.conf
		# The module could do with a reload after adding udev rules
		# modprobe uinput
	    }
	    genericBuild
	)
	# Build roccat-tools.
	(
	    nativeBuildInputs="$out $nativeBuildInputs" # to find libgaminggear
	    source $stdenv/setup
	    src=$toolsSrc
	    mkdir -p $out/etc/xdg/autostart
	    cmakeFlags="$config2 -DGAMINGGEAR0_INCLUDE_DIR=$out/include/gaminggear-0 -DLIBDIR=$out/lib \
	                            -DUDEVDIR=$out/etc/udev/rules.d \
	                            -DCMAKE_MODULE_PATH=$out/usr/share/cmake/Modules"
	    preInstall () {
		substituteInPlace "roccateventhandler/CMakeLists.txt" --replace '/etc/xdg/autostart' "$out/etc/xdg/autostart"
	    }
	    postInstall () {
		# For some unknown as yet reason, the applications segfault on start if not run as super user.
		for desktopfile in $out/share/applications/*.desktop
		    do
			substituteInPlace $desktopfile --replace "Exec=" "Exec=su -c "
			substituteInPlace $desktopfile --replace "Terminal=false" "Terminal=true"
		    done
		### The below will need to be carried out if
		##  the applications are to run as a regular user
		#groupadd -fr roccat
		#mkdir -p $out/var/lib/roccat
		#chown root:roccat $out/var/lib/roccat
		#chmod 2770 $out/var/lib/roccat
		# udevadm control --reload-rules
	    }
	    genericBuild
	)
    '';

  enableParallelBuilding = true;

  meta = {
    inherit version;
    description = "Tools for ROCCAT® hardware";
    homepage = http://sourceforge.net/projects/roccat/;
    license = stdenv.lib.licenses.gpl2Plus;
    platforms = stdenv.lib.platforms.linux;
  };
}
