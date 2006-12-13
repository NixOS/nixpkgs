{stdenv, fetchurl, python, ZopeInterface}:

stdenv.mkDerivation {
  name = "twisted-2.4.0";
  src = fetchurl {
    url = http://tmrc.mit.edu/mirror/twisted/Twisted/2.4/Twisted-2.4.0.tar.bz2;
    md5 = "42eb0c8fd0f8707a39fff1dd6adab27d";
  };
  buildInputs = [python ZopeInterface];
  buildPhase = "true";
  installPhase = "PYTHONPATH=$(toPythonPath $out):$PYTHONPATH; python ./setup.py install --prefix=$out";
}
