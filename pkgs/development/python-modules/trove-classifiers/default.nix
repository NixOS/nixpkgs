{
  lib,
  buildPythonPackage,
  fetchPypi,
  calver,
  pytestCheckHook,
  setuptools,
}:

let
  self = buildPythonPackage rec {
    pname = "trove-classifiers";
<<<<<<< HEAD
    version = "2025.11.14.15";
=======
    version = "2025.9.11.17";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    pyproject = true;

    src = fetchPypi {
      pname = "trove_classifiers";
      inherit version;
<<<<<<< HEAD
      hash = "sha256-a2D0nUC72JW8YdjcQU/C8ihtcOty7SNUjbjPlPYoBMo=";
=======
      hash = "sha256-kxyphBpenJQIvCrme1DSis+FvvViGbVoYIdt0fLQJN0=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    };

    postPatch = ''
      substituteInPlace tests/test_cli.py \
        --replace-fail "BINDIR = Path(sys.executable).parent" "BINDIR = '$out/bin'"
    '';

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
      mainProgram = "trove-classifiers";
      maintainers = with lib.maintainers; [ dotlambda ];
    };
  };
in
self
