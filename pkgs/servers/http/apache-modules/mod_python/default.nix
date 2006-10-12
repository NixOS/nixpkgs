{stdenv, fetchurl, apacheHttpd, python}:

stdenv.mkDerivation {
  name = "mod_python-3.2.10";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://nix.cs.uu.nl/dist/tarballs/mod_python-3.2.10.tgz;
    md5 = "cc6439f546a6e70cfff7ca51b8c62541";
  };

  patches = [./install.patch];

  inherit apacheHttpd;
  buildInputs = [apacheHttpd python];
}
