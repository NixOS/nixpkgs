{ lib, stdenv, fetchurl, python3, makeWrapper, libxml2 }:

stdenv.mkDerivation rec {
  pname = "doclifter";
  version = "2.21";
  src = fetchurl {
    url = "http://www.catb.org/~esr/${pname}/${pname}-${version}.tar.gz";
    sha256 = "sha256-3zb+H/rRmU87LWh0+kQtiRMZ4JwJ3tVrt8vQ/EeKx8Q=";
  };
  buildInputs = [ python3 ];
  nativeBuildInputs = [ python3 makeWrapper ];

  strictDeps = true;

  makeFlags = [ "PREFIX=$(out)" ];

  preInstall = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    substituteInPlace manlifter \
      --replace '/usr/bin/env python2' '/usr/bin/env python3'
    2to3 -w manlifter
    cp manlifter $out/bin
    wrapProgram "$out/bin/manlifter" \
        --prefix PATH : "${libxml2}/bin:$out/bin"
    cp manlifter.1 $out/share/man/man1
  '';

  meta = {
    description = "Lift documents in nroff markups to XML-DocBook";
    homepage = "http://www.catb.org/esr/doclifter";
    license = "BSD";
    platforms = lib.platforms.unix;
  };
}
