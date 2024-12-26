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
  ptable,
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
  zeep,
}:

buildPythonPackage rec {
  pname = "softlayer";
  version = "6.2.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "softlayer";
    repo = "softlayer-python";
    tag = "v${version}";
    hash = "sha256-wDLMVonPUexoaZ60kRBILmr5l46yajzACozCp6uETGY=";
  };

  build-system = [
    setuptools
  ];

  pythonRelaxDeps = [
    "rich"
  ];

  dependencies = [
    click
    prettytable
    prompt-toolkit
    ptable
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
    zeep
  ];

  # Otherwise soap_tests.py will fail to create directory
  # Permission denied: '/homeless-shelter'
  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = lib.optionals stdenv.hostPlatform.isDarwin [
    # SoftLayer.exceptions.TransportError: TransportError(0): ('Connection aborted.', ConnectionResetError(54, 'Connection reset by peer'))
    "--deselect=tests/CLI/modules/hardware/hardware_basic_tests.py::HardwareCLITests"
  ];

  disabledTestPaths = [
    # Test fails with ConnectionError trying to connect to api.softlayer.com
    "tests/transports/soap_tests.py.unstable"
  ];

  pythonImportsCheck = [ "SoftLayer" ];

  meta = {
    description = "Python libraries that assist in calling the SoftLayer API";
    homepage = "https://github.com/softlayer/softlayer-python";
    changelog = "https://github.com/softlayer/softlayer-python/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
  };
}
