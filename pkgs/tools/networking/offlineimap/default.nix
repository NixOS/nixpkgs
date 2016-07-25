{ stdenv, fetchFromGitHub, pythonPackages, sqlite3 }:

pythonPackages.buildPythonApplication rec {
  version = "7.0.0";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "15m0z3y3gxx30b980gym0mnc2icmdy2xy2ckcbmwp97ynm7pmzmp";
  };

  doCheck = false;

  propagatedBuildInputs = [ sqlite3 pythonPackages.six ];

  meta = {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = "http://offlineimap.org";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.garbas ];
  };
}
