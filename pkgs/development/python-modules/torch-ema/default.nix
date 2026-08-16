{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  torch,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "torch-ema";
  version = "0.3.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "fadel";
    repo = "pytorch_ema";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OOF5Lb3HEIBXc1WXoUp7y44pheDc5oX/7L1vTrwNS2o=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    torch
  ];

  pythonImportsCheck = [ "torch_ema" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  disabledTests = lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
    # aarch64-linux fails cpuinfo test, because /sys/devices/system/cpu/ does not exist in the sandbox:
    # RuntimeError: Failed to initialize cpuinfo!
    "test_state_dict_types"
    "test_to"
  ];

  meta = {
    description = "Tiny PyTorch library for maintaining a moving average of a collection of parameters";
    homepage = "https://github.com/fadel/pytorch_ema";
    changelog = "https://github.com/fadel/pytorch_ema/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
