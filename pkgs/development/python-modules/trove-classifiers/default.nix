{
  lib,
  buildPythonPackage,
  fetchPypi,
  calver,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

let
  self = buildPythonPackage rec {
    pname = "trove-classifiers";
    version = "2024.9.12";
    pyproject = true;

    disabled = pythonOlder "3.7";

    src = fetchPypi {
      pname = "trove_classifiers";
      inherit version;
      hash = "sha256-S0az4TSk0BmZrFvG5SivzBDMSPD3JPGF8mfidgBXaPQ=";
    };

    build-system = [
      calver
      setuptools
    ];

    doCheck = false; # avoid infinite recursion with hatchling

    nativeCheckInputs = [ pytestCheckHook ];

    pythonImportsCheck = [ "trove_classifiers" ];

    passthru.tests.trove-classifiers = self.overridePythonAttrs { doCheck = true; };

    meta = {
      description = "Canonical source for classifiers on PyPI";
      homepage = "https://github.com/pypa/trove-classifiers";
      changelog = "https://github.com/pypa/trove-classifiers/releases/tag/${version}";
      license = lib.licenses.asl20;
      maintainers = with lib.maintainers; [ dotlambda ];
    };
  };
in
self
