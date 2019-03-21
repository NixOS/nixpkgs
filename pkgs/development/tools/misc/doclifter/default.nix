{stdenv, fetchurl, python}:

stdenv.mkDerivation {
  name = "doclifter-2.18";
  src = fetchurl {
    url = http://www.catb.org/~esr/doclifter/doclifter-2.18.tar.gz;
    sha256 = "0g39lbml7dclm2nb20j4ffzhq28226qiwxq1w37p7mpqijm7x3hw";
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
