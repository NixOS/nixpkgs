{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "sqlitedict";
  version = "1.7.0";

  src = fetchFromGitHub {
    owner = "RaRe-Technologies";
    repo = "sqlitedict";
    rev = version;
    sha256 = "08fr81rz1fz35d35kravg7vl234aqagr9wqb09x6wi9lx9zkkh28";
  };

  preCheck = ''
    mkdir tests/db
  '';

  checkInputs = [
    pytestCheckHook
  ];

  meta = with lib; {
    description = "Persistent, thread-safe dict";
    homepage = "https://github.com/RaRe-Technologies/sqlitedict";
    license = licenses.asl20;
    maintainers = [ maintainers.arnoldfarkas ];
  };
}
