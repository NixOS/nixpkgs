{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  aiohttp,
  flake8,
  pytest,
  pytest-asyncio,
  pytest-cov-stub,
  setuptools,
}:

buildPythonPackage rec {
  pname = "throttler";
  version = "1.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "uburuntu";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-fE35zPjBUn4e1VRkkIUMtYJ/+LbnUxnxyfnU+UEPwr4=";
  };

  build-system = [ setuptools ];

  nativeCheckInputs = [
    aiohttp
    flake8
    pytest
    pytest-asyncio
    pytestCheckHook
  ];

  pytestFlagsArray = [ "tests/" ];

  meta = {
    description = "Zero-dependency Python package for easy throttling with asyncio support";
    homepage = "https://github.com/uburuntu/throttler";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ renatoGarcia ];
  };
}
