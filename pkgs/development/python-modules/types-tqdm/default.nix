{ lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, setuptools
}:

buildPythonPackage rec {
  pname = "types-tqdm";
  version = "4.66.0.20240106";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-es9KreW6097XbrgpeD+ZYbHCGHlI6qbdGuhkTf+VqTg=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  # This package does not have tests.
  doCheck = false;

  meta = with lib; {
    description = "Typing stubs for tqdm";
    homepage = "https://pypi.org/project/types-tqdm/";
    license = licenses.asl20;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
