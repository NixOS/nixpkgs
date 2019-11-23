{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, aiofiles
, graphene
, itsdangerous
, jinja2
, pyyaml
, requests
, ujson
, pytest
, python
, uvicorn
, isPy27
, darwin
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.12.10";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "e41ef52e711a82ef95c195674e5d8d41c75c6b1d6f5a275637eedd4cc2150a7f";
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
  ] ++ stdenv.lib.optional stdenv.isDarwin [ darwin.apple_sdk.frameworks.ApplicationServices ];

  checkPhase = ''
    ${python.interpreter} -c """
from starlette.applications import Starlette
app = Starlette(debug=True)
"""
  '';

  meta = with lib; {
    homepage = https://www.starlette.io/;
    description = "The little ASGI framework that shines";
    license = licenses.bsd3;
    maintainers = with maintainers; [ wd15 ];
  };
}
