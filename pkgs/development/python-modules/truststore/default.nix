{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core_3,
  httpx,
  pyopenssl,
  requests,
  trustme,
}:

buildPythonPackage rec {
  pname = "truststore";
  version = "0.10.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "truststore";
    tag = "v${version}";
    hash = "sha256-Pnz8Go1v5RXFmMkWYrmA7WzSsn+eQHIg4Yb+wlur5m4=";
  };

  build-system = [ flit-core_3 ];

  dependencies = [
    aiohttp
    httpx
    pyopenssl
    requests
    trustme
  ];

  # Tests requires networking
  doCheck = false;

  pythonImportsCheck = [ "truststore" ];

  meta = {
    description = "Verify certificates using native system trust stores";
    homepage = "https://github.com/sethmlarson/truststore";
    changelog = "https://github.com/sethmlarson/truststore/blob/v${version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ anthonyroussel ];
  };
}
