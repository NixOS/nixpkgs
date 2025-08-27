{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  requests,
  setuptools,
}:

buildPythonPackage rec {
  pname = "sharkiq";
  version = "1.2.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "JeffResc";
    repo = "sharkiq";
    tag = "v${version}";
    hash = "sha256-bojLyL16DOFgbU8rglzBRxcgsHwaTQQAsJQZCaXo5pw=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    requests
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [ "sharkiq" ];

  meta = with lib; {
    description = "Python API for Shark IQ robots";
    homepage = "https://github.com/JeffResc/sharkiq";
    changelog = "https://github.com/JeffResc/sharkiq/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
