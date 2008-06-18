{fetchurl, stdenv, gupnp, gssdp, pkgconfig, glib, libxml2, libsoup, gtk, libglade, gnomeicontheme, e2fsprogs}:

stdenv.mkDerivation rec {
  name = "gupnp-tools-0.6";
  src = fetchurl {
    url = "http://www.gupnp.org/sources/gupnp-tools/gupnp-tools-0.6.tar.gz";
    sha256 = "08fnggk85zqdcvm4np53yxw15b3ck25c2rmyfrh04g8j25qf50dj";
  };

  buildInputs = [gupnp gssdp pkgconfig glib libxml2 libsoup gtk libglade gnomeicontheme e2fsprogs];
}
