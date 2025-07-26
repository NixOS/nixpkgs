{
  lib,
  aiohttp,
  buildPythonPackage,
  cryptography,
  fetchFromGitHub,
  pythonOlder,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "simplepush";
  version = "2.2.3";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "simplepush";
    repo = "simplepush-python";
    tag = "v${version}";
    hash = "sha256-DvDPihhx1rzJN6iQP5rHluplJ1AaN0b/glcd+tZCues=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    cryptography
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "simplepush" ];

  meta = with lib; {
    description = "Module to send push notifications via Simplepush";
    homepage = "https://github.com/simplepush/simplepush-python";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
