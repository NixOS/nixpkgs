{ lib
, buildPythonPackage
, fetchPypi
, typing-extensions
, python3Packages
, setuptools-scm

}:

buildPythonPackage rec {
  pname = "settngs";
  version = "0.7.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-r09vq9aFXWw0mdqHl3DYZyndrSVwR0XlhKOzy3c/xfo=";
  };

  propagatedBuildInputs = [
    typing-extensions
    python3Packages.pytest
    setuptools-scm
  ];

#  pythonImportsCheck = [ "settngs" ];

  meta = with lib; {
    description = "A library for managing settings";
    homepage = "https://github.com/lordwelch/settngs";
    license = licenses.mit;
    maintainers = with maintainers; [ provenzano ];
  };
}
