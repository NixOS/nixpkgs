{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
}:

buildPythonPackage rec {
  pname = "sockjs";
  version = "0.13.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V+lZoj8gqNVRSdHl2ws7hwcm8rStgWbUG9z0EbNs33Y=";
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
