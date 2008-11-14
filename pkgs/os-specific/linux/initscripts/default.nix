{stdenv, fetchurl, popt, pkgconfig, glib}:

stdenv.mkDerivation {
  name = "initscripts-8.18";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://nixos.org/tarballs/initscripts-8.18.tar.bz2;
    md5 = "1b89ac4d344f1f20fe5022a198b69915";
  };
  buildInputs = [popt pkgconfig glib];
  patches = [./initscripts-8.18.patch];
}
