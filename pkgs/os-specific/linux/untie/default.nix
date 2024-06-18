{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "untie";
  version = "0.3";
  src = fetchurl {
    url = "http://guichaz.free.fr/untie/files/${pname}-${version}.tar.bz2";
    sha256 = "1334ngvbi4arcch462mzi5vxvxck4sy1nf0m58116d9xmx83ak0m";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  meta = with lib; {
    description = "Tool to run processes untied from some of the namespaces";
    mainProgram = "untie";
    maintainers = with maintainers; [ raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2Plus;
  };

  passthru = {
    updateInfo = {
      downloadPage = "http://guichaz.free.fr/untie";
    };
  };
}
