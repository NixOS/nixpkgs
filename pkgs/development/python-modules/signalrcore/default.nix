{
  # lib & utils
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  nix-update-script,
  pytestCheckHook,

  # build
  setuptools,

  # deps
  msgpack,

  # test deps
  requests,
}:

buildPythonPackage rec {
  pname = "signalrcore";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mandrewcito";
    repo = "signalrcore";
    tag = version;
    hash = "sha256-BLbD6IYo4YN1bvB33MIfHUVPEIm1DND5oh/k07e4odI=";
  };

  build-system = [ setuptools ];

  dependencies = [ msgpack ];

  nativeCheckInputs = [
    pytestCheckHook
    requests
  ];

  disabledTests = [
    # requires network access
    "test_check_azure_url"
    "test_send"
    "test_build"
    "test_skip_negotiation"
    "test_unsubscribe"
    "test_enable_trace"
    "test_enable_trace_messagepack"
  ];

  disabledTestPaths = [
    # requires network access
    "test/integration/builder/certificates_test.py"
    "test/integration/connection_state_test.py"
    "test/integration/open_close_test.py"
    "test/integration/reconnection/*"
    "test/integration/send/*"
    "test/integration/streamming/*"
    "test/integration/trace_test.py"
    "test/integration/transport_test.py"
  ];

  pythonImportsCheck = [ "signalrcore" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    mainProgram = "signalrcore";
    description = "Complete Python client for ASP.NET Core SignalR — supporting all transports, encodings, authentication, and reconnection strategies";
    homepage = "https://mandrewcito.github.io/signalrcore";
    changelog = "https://github.com/mandrewcito/signalrcore/releases/tag/${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ vaisriv ];
  };
}
