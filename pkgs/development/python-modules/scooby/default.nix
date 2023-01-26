{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "scooby";
  version = "0.7.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-UgFPRoG8wylZMuDz2Utp5A5hlaaWWzTmiUExLOa2Nt4=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "scooby" ];

  meta = with lib; {
    homepage = "https://github.com/banesullivan/scooby";
    description = "A lightweight tool for reporting Python package versions and hardware resources";
    changelog = "https://github.com/banesullivan/scooby/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
