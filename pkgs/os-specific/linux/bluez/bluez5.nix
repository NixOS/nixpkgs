{ stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib, python,
  pythonPackages, pythonDBus, readline, libsndfile, udev, libical,
  systemd }:

assert stdenv.isLinux;

stdenv.mkDerivation rec {
  name = "bluez-5.8";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.xz";
    sha256 = "1l33lq1lpg7hy26138ir5dj4gl3mql2qxpj20rjnnwyckc3jk700";
  };

  pythonPath = with pythonPackages;
    [ pythonDBus pygobject pygobject3 recursivePthLoader ];

  buildInputs =
    [ pkgconfig dbus.libs glib libusb alsaLib python pythonPackages.wrapPython
      readline libsndfile udev libical
      # Disables GStreamer; not clear what it gains us other than a
      # zillion extra dependencies.
      # gstreamer gst_plugins_base 
    ];

  preConfigure = ''
      substituteInPlace tools/hid2hci.rules --replace /sbin/udevadm ${systemd}/bin/udevadm
      substituteInPlace tools/hid2hci.rules --replace "hid2hci " "$out/lib/udev/hid2hci "
    '';

  configureFlags = [
    "--localstatedir=/var"
    "--enable-library"
    "--enable-cups"
    "--with-dbusconfdir=$(out)/etc"
    "--with-dbussystembusdir=$(out)/share/dbus-1/system-services"
    "--with-dbussessionbusdir=$(out)/share/dbus-1/services"
    "--with-systemdsystemunitdir=$(out)/etc/systemd/system"
    "--with-systemduserunitdir=$(out)/etc/systemd/user"
    "--with-udevdir=$(out)/lib/udev"
    ];

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = "statedir=$(TMPDIR)/var/lib/bluetooth";

  makeFlags = "rulesdir=$(out)/lib/udev/rules.d";

  # FIXME: Move these into a separate package to prevent Bluez from
  # depending on Python etc.
  postInstall = ''
    mkdir $out/test
    cp -a test $out
    pushd $out/test
    for a in \
            simple-agent \
            test-adapter \
            test-device \
            test-thermometer \
            list-devices \
            monitor-bluetooth \
            ; do
      ln -s ../test/$a $out/bin/bluez-$a
    done
    popd
    wrapPythonProgramsIn $out/test "$out/test $pythonPath"

    # for bluez4 compatibility for NixOS
    mkdir $out/sbin
    ln -s ../libexec/bluetooth/bluetoothd $out/sbin/bluetoothd
  '';

  meta = with stdenv.lib; {
    homepage = http://www.bluez.org/;
    description = "Bluetooth support for Linux";
    platforms = platforms.linux;
  };
}
