{ stdenv, fetchFromGitHub, buildPythonApplication, sqlite3 }:

buildPythonApplication rec {
  version = "6.7.0.2";
  name = "offlineimap-${version}";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "OfflineIMAP";
    repo = "offlineimap";
    rev = "v${version}";
    sha256 = "1zin4gz9v3w6181pjyzrmmz53h1l33hnd2qq0brspab80lm1ns3q";
  };

  doCheck = false;

  propagatedBuildInputs = [
    sqlite3
  ];

  meta = {
    description = "Synchronize emails between two repositories, so that you can read the same mailbox from multiple computers";
    homepage = "http://offlineimap.org";
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [ stdenv.lib.maintainers.garbas ];
  };
}
