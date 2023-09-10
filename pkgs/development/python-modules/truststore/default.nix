{ lib
, buildPythonPackage
, fetchFromGitHub
, flit-core
, aiohttp
, httpx
, pyopenssl
, requests
, trustme
}:

buildPythonPackage rec {
  pname = "truststore";
  version = "0.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-K11nHzpckNR8pqmgLOo/yCJ2cNQnqPHgjMDPQkpeRkQ=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    aiohttp
    httpx
    pyopenssl
    requests
    trustme
  ];

  # tests requires networking
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/sethmlarson/truststore";
    description = "Verify certificates using native system trust stores";
    changelog = "https://github.com/sethmlarson/truststore/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
