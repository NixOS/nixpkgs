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
, pytest-asyncio
, pytestcov
, typing-extensions
, ApplicationServices
}:

buildPythonPackage rec {
  pname = "starlette";

  version = "0.14.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "0s0zl0ylxc5d9666zkvbwqfhngvjd79al1y69k674i0pkq2zg50j";
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
    graphene
    pytestCheckHook
    pytest-asyncio
    pytestcov
    typing-extensions
  ];

  pythonImportsCheck = [ "starlette" ];

  meta = with lib; {
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
