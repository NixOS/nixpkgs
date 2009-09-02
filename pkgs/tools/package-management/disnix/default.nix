{stdenv, fetchsvn, autoconf, automake, libtool, pkgconfig, dbus_glib, openssl, libxml2}:

stdenv.mkDerivation {
  name = "disnix-test";
  src = fetchsvn {
    url = https://svn.nixos.org/repos/nix/disnix/disnix/trunk;
    sha256 = "4397dc0bf4b4ecca795784d0011eb631538b17bd81e77b84bf15d89bf85e94bb";
    rev = 16924;
  };
  buildInputs = [ autoconf automake libtool pkgconfig dbus_glib openssl libxml2 ];
  preConfigure = "./bootstrap";
}
