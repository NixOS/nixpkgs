{ stdenv, fetchurl, pkgconfig, dbus_glib, libxml2, libxslt, getopt, nixUnstable, dysnomia, libintlOrEmpty, libiconv }:

stdenv.mkDerivation {
  name = "disnix-0.3pre42e23349a7b4ca84fce6293f79470647a5f5c8e7";
  
  src = fetchurl {
    url = http://hydra.nixos.org/build/20213001/download/4/disnix-0.3pre42e23349a7b4ca84fce6293f79470647a5f5c8e7.tar.gz;
    sha256 = "08f16gi8dg39ll5ph6rs4wdw9dg4sdgnikpg1x40slzcrckvnkhm";
  };
  
  buildInputs = [ pkgconfig dbus_glib libxml2 libxslt getopt nixUnstable libintlOrEmpty libiconv dysnomia ];

  dontStrip = true;
  
  meta = {
    description = "A Nix-based distributed service deployment tool";
    license = stdenv.lib.licenses.lgpl21Plus;
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
