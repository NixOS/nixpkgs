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
, aiosqlite
, databases
, pytestCheckHook
, pytest-cov
, pytest-asyncio
, typing-extensions
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.14.2";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "0fz28czvwiww693ig9vwdja59xxs7m0yp1df32ms1hzr99666bia";
  };

  propagatedBuildInputs = [
    aiofiles
    graphene
    itsdangerous
    jinja2
    python-multipart
    pyyaml
    requests
  ] ++ lib.optional stdenv.isDarwin [ ApplicationServices ];

  checkInputs = [
    aiosqlite
    databases
    pytestCheckHook
    pytest-cov
    pytest-asyncio
    typing-extensions
  ];

  pytestFlagsArray = [ "--ignore=tests/test_graphql.py" ];

  pythonImportsCheck = [ "starlette" ];

  meta = with lib; {
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
