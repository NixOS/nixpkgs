{stdenv, fetchurl, apacheHttpd, python}:

stdenv.mkDerivation {
  name = "mod_python-3.3.1";

  src = fetchurl {
    url = mirror://apache/httpd/modpython/mod_python-3.3.1.tgz;
    sha256 = "0sss2xi6l1a2z8y6ji0cp8vgyvnhq8zrg0ilkvpj1mygbzyk28xd";
  };

  patches = [
    ./install.patch

    # See http://bugs.gentoo.org/show_bug.cgi?id=230211
    (fetchurl {
      url = "http://bugs.gentoo.org/attachment.cgi?id=160400";
      sha256 = "0yx6x9c5rg5kn6y8vsi4xj3nvg016rrfk553ca1bw796v383xkyj";
    })
  ];

  preInstall = ''
    installFlags="LIBEXECDIR=$out/modules $installFlags"
    mkdir -p $out/modules
  '';

  passthru = { inherit apacheHttpd; };
  
  buildInputs = [apacheHttpd python];
}
