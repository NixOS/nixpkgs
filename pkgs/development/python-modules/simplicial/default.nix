{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, wheel
, matplotlib
, numpy
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "simplicial";
  version = "1.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simoninireland";
    repo = "simplicial";
    rev = "v${version}";
    hash = "sha256-o9YoswTthqW+xMrIrSMscRPnqz9A0EGQMXlbuIZ0OWE=";
  };

  nativeBuildInputs = [
    setuptools
    wheel
    pytestCheckHook
  ];

  propagatedBuildInputs = [
    matplotlib
    numpy
  ];

  pythonImportsCheck = [ "simplicial" ];

  meta = with lib; {
    changelog = "https://github.com/simoninireland/simplicial/blob/v${version}/HISTORY";
    description = "Simplicial topology in Python";
    homepage = "https://github.com/simoninireland/simplicial";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ "berber" ];
  };
}
