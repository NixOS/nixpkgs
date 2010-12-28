{stdenv, fetchurl, SDL, zlib, mpeg2dec}:

stdenv.mkDerivation {
  name = "scummvm-1.2.1";
  
  src = fetchurl {
    url = mirror://sourceforge/scummvm/scummvm-1.2.1.tar.bz2;
    sha256 = "029abzvpz85accwk7x79w255wr83gnkqg3yc5n6ryl28zg00z3j8";
  };
  
  buildInputs = [SDL zlib mpeg2dec];

  crossAttrs = {
    preConfigure = ''
      # Remove the --build flag set by the gcc cross wrapper setup
      # hook
      export configureFlags="--host=${stdenv.cross.config}"
    '';
    postConfigure = ''
      # They use 'install -s', that calls the native strip instead of the cross
      sed -i 's/-c -s/-c/' ports.mk;
    '';
  };

  meta = {
    description = "Program to run certain classic graphical point-and-click adventure games (such as Monkey Island)";
    homepage = http://www.scummvm.org/;
  };
}
