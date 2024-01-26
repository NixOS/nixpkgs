{ lib
, buildPythonPackage
, fetchPypi
, calver
, pytestCheckHook
, pythonOlder
, setuptools
}:

let
  self = buildPythonPackage rec {
    pname = "trove-classifiers";
    version = "2023.11.29";
    pyproject = true;

    disabled = pythonOlder "3.7";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-/49/2Cx5MhE7RufvZ0LHAJHMY2QMjGXbANkfLpQLlRQ=";
    };

    postPatch = ''
      substituteInPlace setup.py \
        --replace '"calver"' ""
    '';

    nativeBuildInputs = [
      calver
      setuptools
    ];

    doCheck = false; # avoid infinite recursion with hatchling

    nativeCheckInputs = [
      pytestCheckHook
    ];

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
