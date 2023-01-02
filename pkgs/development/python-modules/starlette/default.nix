{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, hatchling

# runtime
, ApplicationServices
, aiofiles
, anyio
, contextlib2
, itsdangerous
, jinja2
, python-multipart
, pyyaml
, typing-extensions

# tests
, requests
, aiosqlite
, databases
, httpx
, pytestCheckHook
, pythonOlder
, trio
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.23.1";
  format = "pyproject";

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-LcFrdaRgFBqcdylCzNlewj/papsg/sZ1FMVxBDLvQWI=";
  };

  nativeBuildInputs = [
    hatchling
  ];

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
  ] ++ lib.optionals stdenv.isDarwin [
    ApplicationServices
  ];

  checkInputs = [
    aiosqlite
    databases
    httpx
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
