{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, hatchling

# runtime
, ApplicationServices
, anyio
, itsdangerous
, jinja2
, python-multipart
, pyyaml
, httpx
, typing-extensions

# tests
, pytestCheckHook
, pythonOlder
, trio
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.25.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-s0ADo/+lcH8Y31hf1iSLbfTsV3fZtlCuZf7BS0uQc9Y=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  postPatch = ''
    # remove coverage arguments to pytest
    sed -i '/--cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    anyio
    itsdangerous
    jinja2
    python-multipart
    pyyaml
    httpx
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
  ];

  nativeCheckInputs = [
    pytestCheckHook
    trio
    typing-extensions
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
    "-W" "ignore::trio.TrioDeprecationWarning"
  ];

  disabledTests = [
    # asserts fail due to inclusion of br in Accept-Encoding
    "test_websocket_headers"
    "test_request_headers"
  ];

  pythonImportsCheck = [
    "starlette"
  ];

  meta = with lib; {
    changelog = "https://github.com/encode/starlette/releases/tag/${version}";
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
