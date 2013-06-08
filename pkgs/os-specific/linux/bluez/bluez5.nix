{ stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib, python, makeWrapper
, pythonDBus, pygobject, readline, libsndfile, udev, libical, systemd }:

assert stdenv.isLinux;

let
  pythonpath = "${pythonDBus}/lib/${python.libPrefix}/site-packages:"
    + "${pygobject}/lib/${python.libPrefix}/site-packages";
in
   
stdenv.mkDerivation rec {
  name = "bluez-5.3";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.xz";
    sha256 = "41b0559e3a8436a739eb7cc79156ca91daf8c115f57971b6bcb422ee0213db42";
  };

  buildInputs =
    [ pkgconfig dbus.libs glib libusb alsaLib python makeWrapper
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
    pushd test
    for a in \
            simple-agent \
            test-adapter \
            test-device \
            test-thermometer \
            list-devices \
            monitor-bluetooth \
            ; do
      cp $a $out/bin/bluez-$a
      wrapProgram $out/bin/bluez-$a --prefix PYTHONPATH : ${pythonpath}
    done
    popd
  '';

  meta = {
    homepage = http://www.bluez.org/;
    description = "Bluetooth support for Linux";
  };
}
