{
  lib,
  buildPythonPackage,
  fetchPypi,
  calver,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "trove-classifiers";
  version = "2026.9.21.13";
  pyproject = true;

  src = fetchPypi {
    pname = "trove_classifiers";
    inherit (finalAttrs) version;
    hash = "sha256-Cp68jU4vPooihIxSWAMwNb7BejASrD/qFtuqdkSJ63E=";
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

  passthru.tests.trove-classifiers = finalAttrs.finalPackage.overrideAttrs { doInstallCheck = true; };

  meta = {
    description = "Canonical source for classifiers on PyPI";
    homepage = "https://github.com/pypa/trove-classifiers";
    changelog = "https://github.com/pypa/trove-classifiers/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "trove-classifiers";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
