{ pkgs, fetchurl, buildPythonPackage, sqlite3 }:

buildPythonPackage rec {
  version = "6.5.7";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/OfflineIMAP/offlineimap/archive/v${version}.tar.gz";
    sha256 = "18whwc4f8nk8gi3mjw9153c9cvwd3i9i7njmpdbhcplrv33m5pmp";
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
