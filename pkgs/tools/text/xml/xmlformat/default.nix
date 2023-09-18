{ lib, stdenv, fetchurl, perl }:
stdenv.mkDerivation rec {
  pname = "xmlformat";
  version = "1.04";

  src = fetchurl {
    url = "http://www.kitebird.com/software/xmlformat/xmlformat-${version}.tar.gz";
    sha256 = "1vwgzn4ha0az7dx0cyc6dx5nywwrx9gxhyh08mvdcq27wjbh79vi";
  };

  buildInputs = [ perl ];
  buildPhase = ''
    patchShebangs ./xmlformat.pl
  '';

  installPhase = ''
    mkdir -p $out/bin $out/usr/share/$pname
    cp ./xmlformat.pl $out/bin/xmlformat
    cp ./LICENSE $out/usr/share/$pname
  '';

  meta = {
    description = "a configurable formatter (or 'pretty-printer') for XML documents";
    homepage = "http://www.kitebird.com/software/xmlformat/";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.all;
  };
}
