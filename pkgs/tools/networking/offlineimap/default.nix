{ stdenv, fetchFromGitHub, pythonPackages, sqlite3 }:

pythonPackages.buildPythonApplication rec {
  version = "7.0.3";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "1spqnrzml8lfns61y90i8fdyvs6i80fc9n89zv1mxjyv1ks7pp64";
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
