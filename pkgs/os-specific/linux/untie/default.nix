{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "untie-${version}";
  version = "0.3";
  src = fetchurl {
    url = "http://guichaz.free.fr/untie/files/${name}.tar.bz2";
    sha256 = "1334ngvbi4arcch462mzi5vxvxck4sy1nf0m58116d9xmx83ak0m";
  };

  makeFlags = "PREFIX=$(out)";

  meta = with stdenv.lib; {
    description = "A tool to run processes untied from some of the namespaces";
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
