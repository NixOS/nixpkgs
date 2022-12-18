{ lib
, stdenv
, aiosqlite
, anyio
, ApplicationServices
, buildPythonPackage
, databases
, fetchFromGitHub
, hatchling
, httpx
, itsdangerous
, jinja2
, pytestCheckHook
, python-multipart
, pythonOlder
, pyyaml
, trio
, typing-extensions
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.23.0";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-j+UsZtk7W5exWGzIrNiELtE9ehoknfsy1W/5vii+9IE=";
  };

  nativeBuildInputs = [
    hatchling
  ];

  propagatedBuildInputs = [
    anyio
    httpx
    itsdangerous
    jinja2
    python-multipart
    pyyaml
  ] ++ lib.optionals (pythonOlder "3.10") [
    typing-extensions
  ] ++ lib.optional stdenv.isDarwin [
    ApplicationServices
  ];

  checkInputs = [
    aiosqlite
    databases
    pytestCheckHook
    trio
    typing-extensions
  ];

  disabledTests = [
    # Asserts fail due to inclusion of br in Accept-Encoding
    "test_websocket_headers"
    "test_request_headers"
  ];

  pythonImportsCheck = [
    "starlette"
  ];

  pytestFlagsArray = [
    # DeprecationWarning: Please use rfc3986.validators.Validator instead. This method will be eventually removed.
    "-W"
    "ignore::DeprecationWarning"
  ];

  meta = with lib; {
    description = "The little ASGI framework that shines";
    homepage = "https://www.starlette.io/";
    changelog = "https://github.com/encode/starlette/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
