{ lib, stdenv, fetchurl }:

let version = "20141203"; in
stdenv.mkDerivation {
  name = "hdapsd-"+version;

  src = fetchurl {
    url = "https://github.com/evgeni/hdapsd/releases/download/${version}/hdapsd-${version}.tar.gz";
    sha256 = "0ppgrfabd0ivx9hyny3c3rv4rphjyxcdsd5svx5pgfai49mxnl36";
  };

  postInstall = builtins.readFile ./postInstall.sh;

  meta = with lib;
    { description = "Hard Drive Active Protection System Daemon";
      homepage = "http://hdaps.sf.net/";
      license = licenses.gpl2;
      platforms = platforms.linux;
      maintainers = [ maintainers.ehmry ];
    };
}
