{ stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib, pythonPackages, makeWrapper
, readline, libsndfile }:

assert stdenv.isLinux;

let
  inherit (pythonPackages) python;
  pythonpath = "${pythonPackages.dbus}/lib/${python.libPrefix}/site-packages:"
    + "${pythonPackages.pygobject}/lib/${python.libPrefix}/site-packages";
in stdenv.mkDerivation rec {
  name = "bluez-4.101";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "11vldy255zkmmpj0g0a1m6dy9bzsmyd7vxy02cdfdw79ml888wsr";
  };

  buildInputs =
    [ pkgconfig dbus glib libusb alsaLib python makeWrapper
      readline libsndfile
      # Disables GStreamer; not clear what it gains us other than a
      # zillion extra dependencies.
      # gstreamer gst_plugins_base 
    ];

  configureFlags = [
    "--localstatedir=/var"
    "--enable-cups"
    "--with-systemdunitdir=$(out)/etc/systemd/system"
    ];

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = "statedir=$(TMPDIR)/var/lib/bluetooth";

  makeFlags = "rulesdir=$(out)/lib/udev/rules.d";

  /* !!! Move these into a separate package to prevent Bluez from
    depending on Python etc. */
  postInstall = ''
    pushd test
    for a in simple-agent test-adapter test-device test-input; do
      cp $a $out/bin/bluez-$a
      wrapProgram $out/bin/bluez-$a --prefix PYTHONPATH : ${pythonpath}
    done
    popd
  '';

  meta = {
    homepage = http://www.bluez.org/;
    description = "Bluetooth support for Linux";
    platforms = stdenv.lib.platforms.linux;
  };
}
