{ lib
, buildPythonPackage
, fetchPypi

, setuptools
, six
}:

buildPythonPackage rec {
  pname = "slpp";
  version = "1.2.3";
  pyproject = true;

  src = fetchPypi {
    pname = "SLPP";
    inherit version;
    hash = "sha256-If3ZMoNICQxxpdMnc+juaKq4rX7MMi9eDMAQEUy1Scg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    six
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [
    "slpp"
  ];

  meta = with lib; {
    description = "Simple lua-python parser";
    homepage = "https://github.com/SirAnthony/slpp";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
