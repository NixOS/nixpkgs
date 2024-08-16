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
  version = "0.9.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = "truststore";
    rev = "refs/tags/v${version}";
    hash = "sha256-BP88oQ363XFuRMKZqW8wSm1wl5upU+yEgmwktv65JOU=";
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
