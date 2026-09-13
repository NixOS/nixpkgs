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
  version = "2026.6.1.19";
  pyproject = true;

  src = fetchPypi {
    pname = "trove_classifiers";
    inherit (finalAttrs) version;
    hash = "sha256-xRMrS2GoKdEc+9LXLpfyCkXtbtuV5Fxe/eteAINrJ0U=";
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

  __structuredAttrs = true;

  meta = {
    description = "Canonical source for classifiers on PyPI";
    homepage = "https://github.com/pypa/trove-classifiers";
    changelog = "https://github.com/pypa/trove-classifiers/releases/tag/${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "trove-classifiers";
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
