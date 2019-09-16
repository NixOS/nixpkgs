{ lib
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
}:

buildPythonPackage rec {
  pname = "starlette";
  version = "0.12.4";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1m7qf4g5dn7n36406zbqsag71nmwp2dz91yxpplm7h7wiw2xxw93";
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
  ];

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
