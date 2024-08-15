{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools-scm,
  pytestCheckHook,
  pytest-cov-stub,
  nix-update-script,
}:

buildPythonPackage rec {
  pname = "zilliandomizer";
  version = "0.9.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "beauxq";
    repo = "zilliandomizer";
    rev = "v${version}";
    hash = "sha256-CRcvQ0RoaIOwfF1DFDah8sDx76USMZFyl/AVd6H3/rc=";
  };

  build-system = [ setuptools-scm ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "zilliandomizer" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Randomizer for Zillion, a metroidvania style game for the Sega Master System.";
    homepage = "https://github.com/beauxq/zilliandomizer";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}
