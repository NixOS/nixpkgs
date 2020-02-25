{ lib
, stdenv
, buildPythonPackage
, fetchurl
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
  version = "0.12.9";
  disabled = isPy27;

  src = fetchurl {
    url = "https://github.com/encode/starlette/archive/${version}.tar.gz";
    sha256 = "0d3g44hajqmjlr46mf527algqf6a5zh7k7dssl6hwzqm71qr09jp";
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
    graphene
  ];

  checkPhase = ''
    pytest --ignore=tests/test_graphql.py
  '';

  meta = with lib; {
    homepage = https://www.starlette.io/;
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
