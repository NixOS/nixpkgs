{ lib
, buildPythonPackage
, fetchPypi
, calver
, pytestCheckHook
, pythonOlder
}:

<<<<<<< HEAD
let
  self = buildPythonPackage rec {
    pname = "trove-classifiers";
    version = "2023.7.6";
    format = "setuptools";

    disabled = pythonOlder "3.7";

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-io4Wi1HSD+1gcEODHTdjK7UJGdHICmTg8Tk3RGkaiyI=";
    };

    postPatch = ''
      substituteInPlace setup.py \
        --replace '"calver"' ""
    '';

    nativeBuildInputs = [
      calver
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
=======
buildPythonPackage rec {
  pname = "trove-classifiers";
  version = "2023.4.22";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-ZejLOSnjeIFB25Cgd2t2/K++tUik++au5L/ZZW6JmTk=";
  };

  nativeBuildInputs = [
    calver
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "trove_classifiers" ];

  meta = {
    description = "Canonical source for classifiers on PyPI";
    homepage = "https://github.com/pypa/trove-classifiers";
    changelog = "https://github.com/pypa/trove-classifiers/releases/tag/${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
