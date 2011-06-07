{ stdenv, fetchurl, pkgconfig, dbus, glib, libusb, alsaLib, python, makeWrapper
, pythonDBus, pygobject, gst_all, readline, libsndfile }:

assert stdenv.isLinux;

let
  pythonpath = "${pythonDBus}/lib/${python.libPrefix}/site-packages:"
    + "${pygobject}/lib/${python.libPrefix}/site-packages";
in
   
stdenv.mkDerivation rec {
  name = "bluez-4.90";
   
  src = fetchurl {
    url = "mirror://kernel/linux/bluetooth/${name}.tar.gz";
    sha256 = "18wq75m45q00fvddzgfqy1d4368649r2jl3j4yvpijymalc4jra7";
  };

  buildInputs = [ pkgconfig dbus.libs glib libusb alsaLib python makeWrapper
    gst_all.gstreamer gst_all.gstPluginsBase readline libsndfile ];

  configureFlags = "--localstatedir=/var --enable-udevrules --enable-configrules --enable-cups";

  # Work around `make install' trying to create /var/lib/bluetooth.
  installFlags = "statedir=$(TMPDIR)/var/lib/bluetooth";

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
