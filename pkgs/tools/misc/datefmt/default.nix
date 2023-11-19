{ lib, stdenv, fetchurl, datefmt, testers }:

stdenv.mkDerivation rec {
  pname = "datefmt";
  version = "0.2.2";

  src = fetchurl {
    url = "https://cdn.jb55.com/tarballs/datefmt/datefmt-${version}.tar.gz";
    sha256 = "sha256-HgW/vOGVEmAbm8k3oIwIa+cogq7qmX7MfTmHqxv9lhY=";
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
