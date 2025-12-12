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

buildPythonPackage rec {
  pname = "softlayer";
  version = "6.2.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "softlayer";
    repo = "softlayer-python";
    tag = "v${version}";
    hash = "sha256-mlC4o39Ol1ALguc9KGpxB0M0vhWz4LG2uwhW8CBrVgg=";
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

    # Test fails with ConnectionError trying to connect to api.softlayer.com
    "tests/transports/soap_tests.py.unstable"
  ];

  pythonImportsCheck = [ "SoftLayer" ];

  meta = {
    description = "Python libraries that assist in calling the SoftLayer API";
    homepage = "https://github.com/softlayer/softlayer-python";
    changelog = "https://github.com/softlayer/softlayer-python/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
