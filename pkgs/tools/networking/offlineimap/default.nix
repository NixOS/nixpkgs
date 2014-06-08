{ pkgs, fetchurl, buildPythonPackage, sqlite3 }:

buildPythonPackage rec {
  version = "6.5.6";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchurl {
    url = "https://github.com/OfflineIMAP/offlineimap/archive/v${version}.tar.gz";
    sha256 = "1hr8yxb6r8lmdzzly4hafa1l1z9pfx14rsgc8qiy2zxfpg6ijcn2";
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
