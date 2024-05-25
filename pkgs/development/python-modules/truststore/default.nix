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
  format = "pyproject";

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-BP88oQ363XFuRMKZqW8wSm1wl5upU+yEgmwktv65JOU=";
  };

  nativeBuildInputs = [ flit-core ];

  propagatedBuildInputs = [
    aiohttp
    httpx
    pyopenssl
    requests
    trustme
  ];

  # tests requires networking
  doCheck = false;

  pythonImportsCheck = [ "truststore" ];

  meta = with lib; {
    homepage = "https://github.com/sethmlarson/truststore";
    description = "Verify certificates using native system trust stores";
    changelog = "https://github.com/sethmlarson/truststore/blob/v${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
