{ stdenv, fetchFromGitHub, pythonPackages, sqlite3 }:

pythonPackages.buildPythonApplication rec {
  version = "7.0.6";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "14hmr4f9zv1hhl6azh78rg4csincxzkp1sl4wydd4gwyb74cfpkc";
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
