{stdenv, fetchurl, python}:

stdenv.mkDerivation {
  name = "doclifter-2.15";
  src = fetchurl {
    url = http://www.catb.org/~esr/doclifter/doclifter-2.15.tar.gz;
    sha256 = "14k750bxp0kpnm130pp22vx3vmppfnzwisc042din1416ka07yv0";
  };
  buildInputs = [ python ];
  
  makeFlags = "PREFIX=$(out)";
  
  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp manlifter $out/bin
    cp manlifter.1 $out/share/man/man1
  '';
  
  meta = {
    description = "Lift documents in nroff markups to XML-DocBook";
    homepage = http://www.catb.org/esr/doclifter;
    license = "BSD";
    platforms = stdenv.lib.platforms.unix;
  };
}
