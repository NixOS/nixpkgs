{stdenv, fetchurl, python}:

stdenv.mkDerivation {
  name = "doclifter-2.19";
  src = fetchurl {
    url = http://www.catb.org/~esr/doclifter/doclifter-2.19.tar.gz;
    sha256 = "1as6z7mdjrrkw2kism41q5ybvyzvwcmj9qzla2fz98v9f4jbj2s2";
  };
  buildInputs = [ python ];
  
  makeFlags = [ "PREFIX=$(out)" ];
  
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
