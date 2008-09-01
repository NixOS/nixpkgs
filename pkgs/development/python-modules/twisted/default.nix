{stdenv, fetchurl, python, ZopeInterface}:

stdenv.mkDerivation {
  name = "twisted-8.1.0";
  src = fetchurl {
    url = http://tmrc.mit.edu/mirror/twisted/Twisted/8.1/Twisted-8.1.0.tar.bz2;
    sha256 = "0q25zbr4xzknaghha72mq57kh53qw1bf8csgp63pm9sfi72qhirl";
  };
  buildInputs = [python];
  propagatedBuildInputs = [ZopeInterface];
  buildPhase = "true";
  installCommand = "PYTHONPATH=$(toPythonPath $out):$PYTHONPATH; python ./setup.py install --prefix=$out";
}
