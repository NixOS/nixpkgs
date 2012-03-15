{ stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib, python, makeWrapper
, pythonDBus, pygobject, readline, libsndfile }:

assert stdenv.isLinux;

let
  pythonpath = "${pythonDBus}/lib/${python.libPrefix}/site-packages:"
    + "${pygobject}/lib/${python.libPrefix}/site-packages";
in
   
stdenv.mkDerivation rec {
  name = "bluez-4.98";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "9a5b655bada7c7a1921cb3bac83b8a32bbe49893e4c7a1377cdc1b0d35f7d233";
  };

  buildInputs =
    [ pkgconfig dbus.libs glib libusb alsaLib python makeWrapper
      readline libsndfile
      # Disables GStreamer; not clear what it gains us other than a
      # zillion extra dependencies.
      # gstreamer gst_plugins_base 
    ];

  configureFlags = "--localstatedir=/var --enable-cups";

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
  };
}
