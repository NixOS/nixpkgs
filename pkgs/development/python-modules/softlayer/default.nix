{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  click,
  prettytable,
  prompt-toolkit,
  pygments,
  requests,
  rich,
  urllib3,

  # tests
  mock,
  pytestCheckHook,
  sphinx,
  testtools,
  tkinter,
  writableTmpDirAsHomeHook,
  zeep,
}:

buildPythonPackage (finalAttrs: {
  pname = "softlayer";
  version = "6.2.9";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "softlayer";
    repo = "softlayer-python";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kGgCW9N2NZi8PHcfpN+8L2bg7v1edP8ZXYaoSt9545M=";
  };

  build-system = [ setuptools ];

  pythonRelaxDeps = [ "rich" ];

  dependencies = [
    click
    prettytable
    prompt-toolkit
    pygments
    requests
    rich
    urllib3
  ];

  __darwinAllowLocalNetworking = true;

  nativeCheckInputs = [
    mock
    pytestCheckHook
    sphinx
    testtools
    tkinter
    writableTmpDirAsHomeHook
    zeep
  ];

  disabledTestPaths = [
    # SoftLayer.exceptions.TransportError: TransportError(0): ('Connection aborted.', ConnectionResetError(54, 'Connection reset by peer'))
    "tests/CLI/modules/hardware/hardware_basic_tests.py::HardwareCLITests"

    # SystemExit: 1 (or 2)
    "tests/CLI/modules/hardware/hardware_list_tests.py::HardwareListCLITests"
    "tests/CLI/modules/vs/vs_create_tests.py::VirtCreateTests"
    "tests/CLI/modules/vs/vs_tests.py::VirtTests"

    # Test fails with ConnectionError trying to connect to api.softlayer.com
    "tests/transports/soap_tests.py.unstable"
  ];

  disabledTests = [
    # AssertionError
    "test_cf_call_large_dataset"
  ];

  pythonImportsCheck = [ "SoftLayer" ];

  meta = {
    description = "Python libraries that assist in calling the SoftLayer API";
    homepage = "https://github.com/softlayer/softlayer-python";
    changelog = "https://github.com/softlayer/softlayer-python/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
})
