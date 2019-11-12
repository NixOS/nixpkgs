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
  version = "0.12.13";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "9597bc28e3c4659107c1c4a45ec32dc45e947d78fe56230222be673b2c36454a";
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
