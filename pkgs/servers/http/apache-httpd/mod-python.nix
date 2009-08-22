args: with args;
stdenv.mkDerivation {
  name = "apache-httpd-mod-python-3.3.1";

  /*
  src = fetchurl {
    url = mirror://apache/httpd/modpython/mod_python-3.3.1.tgz;
    sha256 = "0sss2xi6l1a2z8y6ji0cp8vgyvnhq8zrg0ilkvpj1mygbzyk28xd";
  };
  */
  src = sourceByName "apacheHttpdModPython";

  buildInputs = [apacheHttpd python];

  configurePhase = ''
    ./configure
  '';

  installPhase = ''
    set -x
    make DESTDIR=$out LIBEXECDIR=/modules install_dso
    make DESTDIR=$out install_py_lib
  '';

  meta = { 
      description = "python module for apache";
      homepage = http://httpd.apache.org/modules/python-download.cgi;
      license = "Apache 2.0";
  };
}
