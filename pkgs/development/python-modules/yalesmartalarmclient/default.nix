{ lib
, backoff
, buildPythonPackage
, fetchFromGitHub
, requests
, pythonOlder
}:

buildPythonPackage rec {
  pname = "yalesmartalarmclient";
  version = "0.3.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "domwillcode";
    repo = "yale-smart-alarm-client";
    rev = "v${version}";
    sha256 = "sha256-CWL1uvmUGLaa2Ho0Ka4wTWstebhe1nQr9R821mweE60=";
  };

  propagatedBuildInputs = [
    backoff
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "yalesmartalarmclient"
  ];

  meta = with lib; {
    description = "Python module to interface with Yale Smart Alarm Systems";
    homepage = "https://github.com/domwillcode/yale-smart-alarm-client";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
