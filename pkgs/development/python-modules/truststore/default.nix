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
  version = "0.7.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "sethmlarson";
    repo = pname;
    rev = "refs/tags/v${version}";
    sha256 = "sha256-Q3HSHcqoG2DEXujL05lj3GLNu4jJ61i7VFxMou8c0cE=";
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
