{ stdenv, fetchFromGitHub, pythonPackages, sqlite3 }:

pythonPackages.buildPythonApplication rec {
  version = "7.0.4";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "1ixm4qp3gljbnbi40h8n6j7c0pzk1ry8hpm4bcf7n68gc07r557n";
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
