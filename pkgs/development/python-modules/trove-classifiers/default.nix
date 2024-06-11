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
    version = "2024.4.10";
    pyproject = true;

    disabled = pythonOlder "3.7";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-SfQLtqdGtyocuk+NVe6CUhac2g9wgC4/0k8Et/slpJI=";
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
