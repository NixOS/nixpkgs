{
  lib,
  buildPythonPackage,
  fetchPypi,
  aiohttp,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sockjs";
  version = "0.13.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-V+lZoj8gqNVRSdHl2ws7hwcm8rStgWbUG9z0EbNs33Y=";
  };

  build-system = [ setuptools ];

  dependencies = [ aiohttp ];

  pythonImportsCheck = [ "sockjs" ];

  meta = with lib; {
    description = "Sockjs server";
    homepage = "https://github.com/aio-libs/sockjs";
    changelog = "https://github.com/aio-libs/sockjs/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ freezeboy ];
  };
}
