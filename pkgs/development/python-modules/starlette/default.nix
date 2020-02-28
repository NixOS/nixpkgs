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
  version = "0.13.2";
  disabled = isPy27;

  src = fetchurl {
    url = "https://github.com/encode/starlette/archive/${version}.tar.gz";
    sha256 = "1snnmbyia7k18di6i3wij4vwmczcr6mj6x9fwrw7ndbil2r36g42";
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
    homepage = https://www.starlette.io/;
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
