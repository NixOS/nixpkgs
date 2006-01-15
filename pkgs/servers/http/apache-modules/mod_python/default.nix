{stdenv, fetchurl, apacheHttpd, python}:

stdenv.mkDerivation {
  name = "mod_python-3.1.4";

  builder = ./builder.sh;

  src = fetchurl {
    url = http://apache.mirror.intouch.nl/httpd/modpython/mod_python-3.1.4.tgz;
    md5 = "607175958137b06bcda91110414c82a1";
  };

  patches = [./install.patch];

  inherit apacheHttpd;
  buildInputs = [apacheHttpd python];
}
