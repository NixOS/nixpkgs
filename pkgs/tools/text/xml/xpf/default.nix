{stdenv, fetchurl, python, libxml2}:

assert libxml2.pythonSupport == true;

stdenv.mkDerivation {
  name = "xpf-0.2";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~mbravenb/software/xpf/xpf-0.2.tar.gz;
    md5 = "d92658828139e1495e052d0cfe25d312";
  };
  buildInputs = [python libxml2];
}
