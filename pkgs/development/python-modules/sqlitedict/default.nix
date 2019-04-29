{ buildPythonPackage, fetchPypi, lib, nose }:

buildPythonPackage rec {
  pname = "sqlitedict";
  version = "1.6.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "096bh8pzqa3djbpb7p21hlgnd6a3yyfv4gj1ip3dwj267h36lga8";
  };

  checkInputs = [ nose ];
  checkPhase = ''
    rm -f -R tests/db/
    mkdir -p tests/db
    nosetests --cover-package=sqlitedict --verbosity=1 --cover-erase -l DEBUG
  '';

  meta = with lib; {
    description = "Persistent dict in Python, backed up by sqlite3 and pickle, multithread-safe";
    license = licenses.asl20;
    homepage = https://github.com/RaRe-Technologies/sqlitedict;
    maintainers = with maintainers; [ mredaelli ];
  };
}
