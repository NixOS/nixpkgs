{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
}:

buildPythonPackage rec {
  pname = "syncer";
  version = "1.3.0";
  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "miyakogi";
    repo = pname;
    rev = "v${version}";
    sha256 = "13y8jllix1ipkcg9lxa4nxk8kj24vivxfizf4d02cdrha9dw500v";
  };

  # Tests require an not maintained package (xfail)
  doCheck = false;

  pythonImportsCheck = [ "syncer" ];

  meta = with lib; {
    description = "Python async to sync converter";
    homepage = "https://github.com/miyakogi/syncer";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
