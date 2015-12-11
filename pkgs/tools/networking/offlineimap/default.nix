{ pkgs, fetchurl, buildPythonPackage, sqlite3 }:

buildPythonPackage rec {
  version = "6.6.0";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/OfflineIMAP/offlineimap/archive/v${version}.tar.gz";
    sha256 = "1x33zxjm3y2p54lbcsgflrs6v2zq785y2k0xi6xia6akrvjmh4n4";
  };

  doCheck = false;

  propagatedBuildInputs = [
    sqlite3
  ];

  meta = {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = "http://offlineimap.org";
    license = pkgs.lib.licenses.gpl2Plus;
    maintainers = [ pkgs.lib.maintainers.garbas ];
  };
}
