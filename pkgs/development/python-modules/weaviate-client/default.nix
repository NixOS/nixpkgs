{
  lib,
  authlib,
  buildPythonPackage,
  deprecation,
  fastapi,
  fetchFromGitHub,
  flask,
  grpcio-health-checking,
  grpcio-tools,
  grpcio,
  h5py,
  httpx,
  litestar,
  numpy,
  pandas,
  polars,
  pydantic,
  pytest-asyncio,
  pytest-httpserver,
  pytestCheckHook,
  pythonOlder,
  requests,
  setuptools-scm,
  validators,
}:

buildPythonPackage rec {
  pname = "weaviate-client";
  version = "4.16.9";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate-python-client";
    tag = "v${version}";
    hash = "sha256-vnBBZUUTv8GVPxjkxqKgTYA9/UaJ7VPr9QoRBIBVek8=";
  };

  pythonRelaxDeps = [
    "httpx"
    "validators"
    "authlib"
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    authlib
    deprecation
    fastapi
    flask
    grpcio
    grpcio-health-checking
    grpcio-tools
    h5py
    httpx
    litestar
    numpy
    pandas
    polars
    pydantic
    requests
    validators
  ];

  nativeCheckInputs = [
    pytest-httpserver
    pytest-asyncio
    pytestCheckHook
  ];

  preCheck = ''
    export HOME=$(mktemp -d)
    sed -i '/raw.githubusercontent.com/,+1d' test/test_util.py
    substituteInPlace pytest.ini \
      --replace-fail "--benchmark-skip" ""
    rm -rf test/test_embedded.py # Need network
  '';

  disabledTests = [
    # Need network
    "test_auth_header_with_catchall_proxy"
    "test_bearer_token"
    "test_client_with_extra_options"
    "test_integration_config"
    "test_refresh_async"
    "test_refresh_of_refresh_async"
    "test_refresh_of_refresh"
    "test_token_refresh_timeout"
    "test_with_simple_auth_no_oidc_via_api_key"
  ];

  enabledTestPaths = [
    "test"
    "mock_tests"
  ];

  __darwinAllowLocalNetworking = true;

  pythonImportsCheck = [ "weaviate" ];

  meta = {
    description = "Python native client for easy interaction with a Weaviate instance";
    homepage = "https://github.com/weaviate/weaviate-python-client";
    changelog = "https://github.com/weaviate/weaviate-python-client/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
    badPlatforms = [
      # weaviate.exceptions.WeaviateGRPCUnavailableError
      lib.systems.inspect.patterns.isDarwin
    ];
  };
}
