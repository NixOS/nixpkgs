{stdenv, fetchurl, automake, autoconf, libtool}:

stdenv.mkDerivation {
  name = "uptimed-0.3.16";
  
  src = fetchurl {
    url = http://podgorny.cz/uptimed/releases/uptimed-0.3.16.tar.bz2;
    sha256 = "0axi2rz4gnmzzjl7xay7y8j1mh6iqqyg0arl1jyc3fgsk1ggy27m";
  };

  patches = [ ./no-var-spool-install.patch ];

  buildInputs = [automake autoconf libtool];

  meta = {
    homepage = http://podgorny.cz/uptimed/;
  };
}
