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
  version = "0.19.0";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "sha256-gjRTMzoQ8pqxjIusRwRXGs72VYo6xsp2DSUxmEr9KxU=";
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
