{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, aiofiles
, anyio
, contextlib2
, graphene
, itsdangerous
, jinja2
, python-multipart
, pyyaml
, requests
, aiosqlite
, databases
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, trio
, typing-extensions
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.16.0";
  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "sha256-/NYhRRZdi6I7CtLCohAqK4prsSUayOxa6sBKIJhPv+w=";
  };

  postPatch = ''
    # remove coverage arguments to pytest
    sed -i '/--cov/d' setup.cfg
  '';

  propagatedBuildInputs = [
    aiofiles
    anyio
    graphene
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
    pytest-asyncio
    pytestCheckHook
    trio
    typing-extensions
  ];

  disabledTestPaths = [
    # fails to import graphql, but integrated graphql support is about to
    # be removed in 0.15, see https://github.com/encode/starlette/pull/1135.
    "tests/test_graphql.py"
  ];

  disabledTests = [
    # asserts fail due to inclusion of br in Accept-Encoding
    "test_websocket_headers"
    "test_request_headers"
  ];

  pythonImportsCheck = [ "starlette" ];

  meta = with lib; {
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
