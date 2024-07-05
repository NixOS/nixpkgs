{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "sockjs";
  version = "0.11.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    sha256 = "A0fUBO2e8xllBnh+2AGPh+5OLQuupJ1CDN1TqWm+wik=";
  };

  propagatedBuildInputs = [ aiohttp ];

  pythonImportsCheck = [ "sockjs" ];

  meta = with lib; {
    description = "Sockjs server";
    homepage = "https://github.com/aio-libs/sockjs";
    license = licenses.asl20;
    maintainers = with maintainers; [ freezeboy ];
  };
}
