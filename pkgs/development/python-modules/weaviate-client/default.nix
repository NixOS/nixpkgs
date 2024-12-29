{
  lib,
  authlib,
  buildPythonPackage,
  fetchFromGitHub,
  grpcio,
  grpcio-health-checking,
  grpcio-tools,
  httpx,
  pydantic,
  pythonOlder,
  requests,
  setuptools-scm,
  validators,
  pytestCheckHook,
  numpy,
  pytest-httpserver,
  pandas,
  polars,
  h5py,
  litestar,
  pytest-asyncio,
  flask,
  fastapi,
}:

buildPythonPackage rec {
  pname = "weaviate-client";
  version = "4.10.2";
  pyproject = true;

  disabled = pythonOlder "3.12";

  src = fetchFromGitHub {
    owner = "weaviate";
    repo = "weaviate-python-client";
    tag = "v${version}";
    hash = "sha256-c2ZO5n/sMrq8f1V+MSwv+pYSzPa9cTBHU8INXHcB8gk=";
  };

  pythonRelaxDeps = [
    "httpx"
    "validators"
    "authlib"
  ];

  build-system = [ setuptools-scm ];

  dependencies = [
    authlib
    grpcio
    flask
    grpcio-health-checking
    grpcio-tools
    h5py
    httpx
    pydantic
    numpy
    litestar
    fastapi
    polars
    requests
    pandas
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
    "test_bearer_token"
    "test_auth_header_with_catchall_proxy"
    "test_token_refresh_timeout"
    "test_with_simple_auth_no_oidc_via_api_key"
    "test_client_with_extra_options"
  ];

  pytestFlagsArray = [
    "test"
    "mock_tests"
  ];

  pythonImportsCheck = [ "weaviate" ];

  meta = {
    description = "Python native client for easy interaction with a Weaviate instance";
    homepage = "https://github.com/weaviate/weaviate-python-client";
    changelog = "https://github.com/weaviate/weaviate-python-client/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ happysalada ];
  };
}
