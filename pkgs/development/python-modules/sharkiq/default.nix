{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
}:

buildPythonPackage rec {
  pname = "sharkiq";
  version = "1.1.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "JeffResc";
    repo = "sharkiq";
    tag = "v${version}";
    hash = "sha256-adSBFH5nGVPo7OBMak6rN5HA5uMKZCqnIVXBnR7REgQ=";
  };

  propagatedBuildInputs = [
    aiohttp
    requests
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "sharkiq" ];

  meta = with lib; {
    description = "Python API for Shark IQ robots";
    homepage = "https://github.com/JeffResc/sharkiq";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
