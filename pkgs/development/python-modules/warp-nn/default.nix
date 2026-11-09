{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  warp-lang,

  # tests
  hypothesis,
  pytestCheckHook,
  torch,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "warp-nn";
  version = "0.4.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "warp-nn";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6wFjPbIQKVupoZu5udMNelUnmQ2VeYykeDiWjoZTBjM=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    warp-lang
  ];

  pythonImportsCheck = [ "warp_nn" ];

  nativeCheckInputs = [
    hypothesis
    pytestCheckHook
    torch
    writableTmpDirAsHomeHook
  ];

  disabledTests = [
    # AssertionError: Arrays are not equal
    "test_boundary_gradients"

    # AssertionError: assert False
    # 'AMD Ryzen Threadripper 9970X 32-Cores, 64 logical cores'.startswith('CPU')
    "test_describe_device"

    # AssertionError: Not equal to tolerance rtol=0.005, atol=1e-06
    "test_extreme_values[cpu-float16-none]"

    # Requires a git repository
    "test_main_baseline_twice"
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isAarch64 [
    # Wrong results on CPUs with SVE (Cortex-A720, Cortex-X925), fine on Neoverse N1
    # AssertionError: [all-close] Failed (at index 0)
    "tests/modules/layers/test_conv_1d.py::test_forward"
    "tests/modules/layers/test_conv_2d.py::test_forward"
  ];

  meta = {
    description = "CUDA Graphable Neural Networks for NVIDIA Warp";
    homepage = "https://github.com/NVIDIA/warp-nn";
    changelog = "https://github.com/NVIDIA/warp-nn/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.tost;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
