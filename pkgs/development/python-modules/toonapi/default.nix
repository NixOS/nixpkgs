{
  lib,
  aiohttp,
  backoff,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  yarl,
}:

buildPythonPackage rec {
  pname = "toonapi";
  version = "0.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "frenck";
    repo = "python-toonapi";
    tag = "v${version}";
    hash = "sha256-RaN9ppqJbTik1/vNX0/YLoBawrqjyQWU6+FLTspIxug=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    backoff
    yarl
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "toonapi" ];

  meta = with lib; {
    description = "Python client for the Quby ToonAPI";
    homepage = "https://github.com/frenck/python-toonapi";
    changelog = "https://github.com/frenck/python-toonapi/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
