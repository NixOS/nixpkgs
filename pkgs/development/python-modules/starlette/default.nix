{ lib
, stdenv
, buildPythonPackage
, fetchFromGitHub
, fetchpatch
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

  version = "0.13.8";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "encode";
    repo = pname;
    rev = version;
    sha256 = "11i0yd8cqwscixajl734g11vf8pghki11c81chzfh8ifmj6mf9jk";
  };

  patches = [
    # a fix for https://github.com/encode/starlette/issues/1131 exposed
    # by newer python 3.8+ versions
    (fetchpatch {
      name = "dont-use-undocumented-tracebackexception-attr.patch";
      url = "https://github.com/encode/starlette/pull/1132/commits/aa97f30c73e1c830e0952f7a97d08bc5fad03dea.patch";
      sha256 = "0clf8l4606y1g585dg4gvx250s2djskji8jaim4s90l9xzjag8sb";
    })
  ];

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
  pythonImportsCheck = [ "starlette" ];

  meta = with lib; {
    homepage = "https://www.starlette.io/";
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
