{stdenv, fetchurl, apacheHttpd, python}:

stdenv.mkDerivation {
  name = "mod_python-3.2.8";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://apache.nedmirror.nl/httpd/modpython/mod_python-3.2.8.tgz;
    md5 = "d03452979a6a334f73cc2b95b39db331";
  };

  patches = [./install.patch ./jg-20060204-1.patch];

  inherit apacheHttpd;
  buildInputs = [apacheHttpd python];
}
