{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, isPy27
, aiofiles
, graphene
, itsdangerous
, jinja2
, python-multipart
, pyyaml
, requests
, ujson
, aiosqlite
, databases
, pytestCheckHook
, pytest-asyncio
, typing-extensions
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.13.8";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "11i0yd8cqwscixajl734g11vf8pghki11c81chzfh8ifmj6mf9jk";
  };

  propagatedBuildInputs = [
    aiofiles
    graphene
    itsdangerous
    jinja2
    python-multipart
    pyyaml
    requests
    ujson
  ] ++ lib.optional stdenv.isDarwin [ ApplicationServices ];

  checkInputs = [
    aiosqlite
    databases
    pytest-asyncio
    pytestCheckHook
    typing-extensions
  ];

  disabledTestPaths = [ "tests/test_graphql.py" ];
  # https://github.com/encode/starlette/issues/1131
  disabledTests = [ "test_debug_html" ];
  pythonImportsCheck = [ "starlette" ];

  meta = with lib; {
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
