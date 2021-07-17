{lib, stdenv, fetchurl, python3}:

stdenv.mkDerivation rec {
  pname = "doclifter";
  version = "2.19";
  src = fetchurl {
    url = "http://www.catb.org/~esr/${pname}/${pname}-${version}.tar.gz";
    sha256 = "1as6z7mdjrrkw2kism41q5ybvyzvwcmj9qzla2fz98v9f4jbj2s2";
  };
  buildInputs = [ python3 ];

  strictDeps = true;

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    cp manlifter $out/bin
    cp manlifter.1 $out/share/man/man1
  '';

  meta = {
    description = "Lift documents in nroff markups to XML-DocBook";
    homepage = "http://www.catb.org/esr/doclifter";
    license = "BSD";
    platforms = lib.platforms.unix;
  };
}
