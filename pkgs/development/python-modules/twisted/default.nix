{stdenv, fetchurl, python, ZopeInterface}:

stdenv.mkDerivation {
  name = "twisted-2.5.0";
  src = fetchurl {
    url = http://tmrc.mit.edu/mirror/twisted/Twisted/2.5/Twisted-2.5.0.tar.bz2;
    sha256 = "1kfj4354lm4kphm317giyldykyd17lba2xd7y512lxc38hzxzcpk";
  };
  buildInputs = [python];
  propagatedBuildInputs = [ZopeInterface];
  buildPhase = "true";
  installCommand = "PYTHONPATH=$(toPythonPath $out):$PYTHONPATH; python ./setup.py install --prefix=$out";
}
