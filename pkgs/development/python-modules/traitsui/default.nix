{ lib
, fetchPypi
, buildPythonPackage
, setuptools
, traits
, pyface
, pythonOlder
}:

buildPythonPackage rec {
  pname = "traitsui";
  version = "8.0.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-kBudHLxFUT4Apzl2d7CYRBsod0tojzChWbrUgBv0A2Q=";
  };

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    traits
    pyface
  ];

  # Needs X server
  doCheck = false;

  pythonImportsCheck = [
    "traitsui"
  ];

  meta = with lib; {
    description = "Traits-capable windowing framework";
    homepage = "https://github.com/enthought/traitsui";
    changelog = "https://github.com/enthought/traitsui/releases/tag/${version}";
    license = licenses.bsdOriginal;
    maintainers = with maintainers; [ knedlsepp ];
  };
}
