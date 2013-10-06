{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "gnuvd-1.0.10";

  src = fetchurl {
    url = http://www.djcbsoftware.nl/code/gnuvd/gnuvd-1.0.10.tar.gz ;
    sha256 = "07mlynarcaal74ibbpqrsd982jmw6xfwgvcp9n6191d4h56a000s";
  };

  meta = {
    description = "Command-line dutch dictionary application";
    homepage = http://www.djcbsoftware.nl/code/gnuvd/;
  };
}
