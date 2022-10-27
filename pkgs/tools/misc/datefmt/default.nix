{ lib, stdenv, fetchurl, datefmt, testers }:

stdenv.mkDerivation rec {
  pname = "datefmt";
  version = "0.2.1";

  src = fetchurl {
    url = "http://cdn.jb55.com/tarballs/datefmt/datefmt-${version}.tar.gz";
    sha256 = "5d5e765380afe39eb39d48f752aed748b57dfd843a4947b2a6d18ab9b5e68092";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.tests.version = testers.testVersion { package = datefmt; };

  meta = with lib; {
    homepage = "https://jb55.com/datefmt";
    description = "A tool that formats timestamps in text streams";
    platforms = platforms.all;
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ jb55 ];
  };
}
