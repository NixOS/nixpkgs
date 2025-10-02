{
  # lib & utils
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  nix-update-script,
  setuptools,

  # deps
  matplotlib,
  numpy,

  # tests
  pytestCheckHook,
  pandas,
}:

buildPythonPackage rec {
  pname = "timple";
  version = "0.1.8";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "theOehrly";
    repo = "timple";
    tag = "v${version}";
    hash = "sha256-tfw+m1ZrU5A9KbXmMS4c1AIP4f/9YT3/o7HRb/uxUSM";
  };

  build-system = [ setuptools ];

  dependencies = [
    matplotlib
    numpy
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pandas
  ];
  pythonImportsCheck = [ "timple" ];

  disabledTests = [
    # wants write access to nix store
    "test_mpl_default_functionality"
  ];
  disabledTestPaths = [
    # gui plotting tests
    "timple/tests/test_timple.py"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/theOehrly/timple/releases/tag/v${version}";
    description = "Extended functionality for plotting timedelta-like values with Matplotlib";
    homepage = "https://github.com/theOehrly/timple";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vaisriv ];
  };
}
