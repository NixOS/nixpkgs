{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "scooby";
  version = "0.7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-scD/uuAtepatt8Yn7b6PJMfSj9AT7iOy0HuVHyVvEhk=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  pythonImportsCheck = [ "scooby" ];

  meta = with lib; {
    homepage = "https://github.com/banesullivan/scooby";
    description = "A lightweight tool for reporting Python package versions and hardware resources";
    license = licenses.mit;
    maintainers = with maintainers; [ wegank ];
  };
}
