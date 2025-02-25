{
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  lib,
  lxml,
  pkce,
  setuptools,
  shortuuid,
}:

buildPythonPackage rec {
  pname = "wolf-comm";
  version = "0.0.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "janrothkegel";
    repo = "wolf-comm";
    tag = version;
    hash = "sha256-majkiDGyR6qHMi6VmlopWAJK7rXPPR5TeAw6gPjiCw8=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    httpx
    lxml
    pkce
    shortuuid
  ];

  pythonImportsCheck = [ "wolf_comm" ];

  # upstream has no tests
  doCheck = false;

  meta = {
    changelog = "https://github.com/janrothkegel/wolf-comm/releases/tag/${src.tag}";
    description = "Communicate with Wolf SmartSet Cloud";
    homepage = "https://github.com/janrothkegel/wolf-comm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
