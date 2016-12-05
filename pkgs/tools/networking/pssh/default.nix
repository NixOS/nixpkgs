{ stdenv, fetchurl, python }:

stdenv.mkDerivation {
  name = "pssh-2.3.1";

  src = fetchurl {
    url = https://parallel-ssh.googlecode.com/files/pssh-2.3.1.tar.gz;
    sha256 = "539f8d8363b722712310f3296f189d1ae8c690898eca93627fc89a9cb311f6b4";
  };

  buildInputs = [ python ];

  buildPhase = "python setup.py build";

  installPhase = "python setup.py install --prefix=$out";

  meta = {
    description = "Parallel SSH tool";
    homepage = https://code.google.com/p/parallel-ssh/;
  };
}
