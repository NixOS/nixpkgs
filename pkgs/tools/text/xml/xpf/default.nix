{stdenv, fetchurl, python, libxml2}:

assert libxml2.pythonSupport == true;

stdenv.mkDerivation {
  name = "xpf-0.1";
  src = fetchurl {
    url = http://losser.st-lab.cs.uu.nl/~mbravenb/software/xpf/xpf-0.1.tar.gz;
    md5 = "e762783664e4bbb3bb2e38a9ea821fa6";
  };
  buildInputs = [python libxml2];
}
