{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  httpx,
  pyopenssl,
  requests,
  trustme,
}:

buildPythonPackage rec {
  pname = "truststore";
  version = "0.10.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "truststore";
    tag = "v${version}";
    hash = "sha256-EbwD2YyVA9W9cWEjYvypBJxs6Hbkb/tF2qU/sUNCt5g=";
  };

  build-system = [ flit-core ];

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
