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
  version = "0.13.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "6bd414152d40d000ccbf6aa40ed89718b40868366a0f69fb83034f416303acef";
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
