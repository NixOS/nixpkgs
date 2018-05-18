{stdenv, fetchurl, python}:

stdenv.mkDerivation {
  name = "doclifter-2.17";
  src = fetchurl {
    url = http://www.catb.org/~esr/doclifter/doclifter-2.17.tar.gz;
    sha256 = "1m8yfjbl8wzcml9q4k7m1crwid0a14r07fqf33bmmgx1zpjk8kmv";
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
