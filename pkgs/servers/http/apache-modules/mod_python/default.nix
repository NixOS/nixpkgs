{stdenv, fetchurl, apacheHttpd, python}:

stdenv.mkDerivation {
  name = "mod_python-3.3.1";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://archive.eu.apache.org/dist/httpd/modpython/mod_python-3.3.1.tgz;
    sha256 = "0sss2xi6l1a2z8y6ji0cp8vgyvnhq8zrg0ilkvpj1mygbzyk28xd";
  };

  patches = [./install.patch];

  inherit apacheHttpd;
  buildInputs = [apacheHttpd python];
}
