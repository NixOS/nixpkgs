{ pkgs, fetchurl, buildPythonPackage, sqlite3 }:

buildPythonPackage rec {
  version = "6.5.5";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/OfflineIMAP/offlineimap/archive/v${version}.tar.gz";
    sha256 = "00k84qagph3xnxss6rkxm61x07ngz8fvffx4z9jyw5baf3cdd32p";
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
