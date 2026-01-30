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
    version = "2025.12.1.14";
    pyproject = true;

    src = fetchPypi {
      pname = "trove_classifiers";
      inherit version;
      hash = "sha256-p08EAFJPyDYgqb50oHB0tcvnWU/U2X/Uwr/eYl/cFjM=";
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
