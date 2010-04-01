{stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable}:

stdenv.mkDerivation {
  name = "disnix-0.1";
  src = fetchurl {
    url = http://hydra.nixos.org/build/334661/download/1/disnix-0.1.tar.gz;
    sha256 = "0qiskbgn49dihhicczsbjandwjnz04yhnlxgwjinkcyfzsh4yqdp";
  };
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable ];
}
