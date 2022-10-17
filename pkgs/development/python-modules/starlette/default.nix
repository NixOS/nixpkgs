{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, aiofiles
, anyio
, contextlib2
, itsdangerous
, jinja2
, python-multipart
, pyyaml
, requests
, aiosqlite
, databases
, pytestCheckHook
, pythonOlder
, trio
, typing-extensions
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.20.4";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-vP2TJPn9lRGnLGkO8lUmnsoT6rSnhuWDD3WqNk76SM0=";
  };

  postPatch = ''
    # remove coverage arguments to pytest
    sed -i '/--cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    aiofiles
    anyio
    itsdangerous
    jinja2
    python-multipart
    pyyaml
    requests
  ] ++ lib.optionals (pythonOlder "3.8") [
    typing-extensions
  ] ++ lib.optionals (pythonOlder "3.7") [
    contextlib2
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
    # asserts fail due to inclusion of br in Accept-Encoding
    "test_websocket_headers"
    "test_request_headers"
  ];

  pythonImportsCheck = [
    "starlette"
  ];

  meta = with lib; {
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
