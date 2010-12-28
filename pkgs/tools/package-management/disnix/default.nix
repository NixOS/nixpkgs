{stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, gettext, libiconv}:

stdenv.mkDerivation {
  name = "disnix-0.2pre25293";
  src = fetchurl {
    url = http://hydra.nixos.org/build/829056/download/4/disnix-0.2pre25293.tar.gz;
    sha256 = "0nsq0kk390x3s8wvdp043n1mdi6jb43770d8s3vsc96qiajs1b9j";
  };
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable ]
                ++ stdenv.lib.optional (!stdenv.isLinux) libiconv
		++ stdenv.lib.optional (!stdenv.isLinux) gettext;
  dontStrip = true;
  NIX_STRIP_DEBUG = true;
}
