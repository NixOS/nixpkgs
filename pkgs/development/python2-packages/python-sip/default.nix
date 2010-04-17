{ stdenv, fetchurl, python }:

stdenv.mkDerivation {
  name = "sip-4.8.2";
  
  src = fetchurl {
    url = http://pyqwt.sourceforge.net/support/sip-4.8.2.tar.gz; # Not downloading from riverbank, since they remove older releases
    sha256 = "1afr2qaibzgf8fq4fmc31jz9hvbwxbg5jvl68ygvkkdvnbg2kfrf";
  };
  
  configurePhase = "python ./configure.py -d $out/lib/${python.libPrefix}/site-packages -b $out/bin -e $out/include";
  
  buildInputs = [ python ];
  
  meta = {
    description = "Creates C++ bindings for Python modules";
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.sander ];
  };
}
