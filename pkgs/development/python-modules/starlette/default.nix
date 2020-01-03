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
  version = "0.12.9";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = "starlette";
    rev = version;
    sha256 = "0w44s8ynzy8w8dgm755c8jina9i4dd87vqkcv7jc1kwkg384w9i5";
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
