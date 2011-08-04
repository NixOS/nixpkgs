{ stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib, python, makeWrapper
, pythonDBus, pygobject, gst_all, readline, libsndfile }:

assert stdenv.isLinux;

let
  pythonpath = "${pythonDBus}/lib/${python.libPrefix}/site-packages:"
    + "${pygobject}/lib/${python.libPrefix}/site-packages";
in
   
stdenv.mkDerivation rec {
  name = "bluez-4.95";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "1xi087x2ggdywq63qp55wvi1iclk50hc42fp40kcsazw23j9vsnn";
  };

  buildInputs =
    [ pkgconfig dbus.libs glib libusb alsaLib python makeWrapper
      readline libsndfile
      # Disables GStreamer; not clear what it gains us other than a
      # zillion extra dependencies.
      # gst_all.gstreamer gst_all.gstPluginsBase 
    ];

  configureFlags = "--localstatedir=/var --enable-cups";

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = "statedir=$(TMPDIR)/var/lib/bluetooth";

  makeFlags = "rulesdir=$(out)/lib/udev/rules.d";

  /* !!! Move these into a separate package to prevent Bluez from
    depending on Python etc. */
  postInstall = ''
    pushd test
    for a in simple-agent test-adapter test-device; do
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
