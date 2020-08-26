{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, aiofiles
, graphene
, itsdangerous
, jinja2
, pyyaml
, requests
, ujson
, python-multipart
, pytest
, uvicorn
, isPy27
, darwin
, databases
, aiosqlite
}:

buildPythonPackage rec {
  pname = "starlette";

  # This is not the latest version of Starlette, however, later
  # versions of Starlette break FastAPI due to
  # https://github.com/tiangolo/fastapi/issues/683. Please update when
  # possible. FastAPI is currently Starlette's only dependent.

  version = "0.13.6";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "08d1d4qdwhi1xxag4am5ijingdyn0mbyqajs9ql5shxnybyjv321";
  };

  propagatedBuildInputs = [
    aiofiles
    graphene
    itsdangerous
    jinja2
    pyyaml
    requests
    ujson
    uvicorn
    python-multipart
    databases
  ] ++ stdenv.lib.optional stdenv.isDarwin [ darwin.apple_sdk.frameworks.ApplicationServices ];

  checkInputs = [
    pytest
    aiosqlite
  ];

  checkPhase = ''
    pytest --ignore=tests/test_graphql.py
  '';

  meta = with lib; {
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
