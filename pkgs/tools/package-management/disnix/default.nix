{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.3pre9d3acde83aa4283cb6fc26874c524a98f39a5bc6";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/20103891/download/4/disnix-0.3pre9d3acde83aa4283cb6fc26874c524a98f39a5bc6.tar.gz;
    sha256 = "04ryf4qlw5jv0xjn6pqy5lkxqlynycsgdjin3ivfhq3pm6i0v65l";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconv dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
