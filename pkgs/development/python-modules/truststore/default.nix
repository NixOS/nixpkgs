{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  flit-core,
  httpx,
  pyopenssl,
  pythonOlder,
  requests,
  trustme,
}:

buildPythonPackage rec {
  pname = "truststore";
  version = "0.10.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "truststore";
    tag = "v${version}";
    hash = "sha256-oVFNR8qxEmCZdTGqzb9Gj3XIUwPy6YWV3YJPkIDA8Cw=";
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

  meta = with lib; {
    description = "Verify certificates using native system trust stores";
    homepage = "https://github.com/sethmlarson/truststore";
    changelog = "https://github.com/sethmlarson/truststore/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
