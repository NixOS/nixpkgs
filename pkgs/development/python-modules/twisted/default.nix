{stdenv, fetchurl, python, ZopeInterface, makeWrapper}:

stdenv.mkDerivation {
  name = "twisted-8.1.0";
  src = fetchurl {
    url = http://tmrc.mit.edu/mirror/twisted/Twisted/8.1/Twisted-8.1.0.tar.bz2;
    sha256 = "0q25zbr4xzknaghha72mq57kh53qw1bf8csgp63pm9sfi72qhirl";
  };
  buildInputs = [python];

  propagatedBuildInputs = [ZopeInterface makeWrapper];

  installPhase = ''
     python ./setup.py install --prefix=$out --install-lib=$(toPythonPath $out) -O1
     for n in $out/bin/*; do wrapProgram $n --set PYTHONPATH "$(toPythonPath $out):$PYTHONPATH:\$PYTHONPATH"; done
  '';
}
