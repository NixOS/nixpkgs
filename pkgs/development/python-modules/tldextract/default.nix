{ lib, fetchPypi, buildPythonPackage
, requests, requests-file, idna, pytest
, responses
}:

buildPythonPackage rec {
  pname   = "tldextract";
  version = "2.2.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1lcywabjy7vpm6awl2cw4m6rk6h85qnbql0j33xcfryy2dhfyaxp";
  };

  propagatedBuildInputs = [ requests requests-file idna ];
  checkInputs = [ pytest responses ];

  meta = {
    homepage = https://github.com/john-kurkowski/tldextract;
    description = "Accurately separate the TLD from the registered domain and subdomains of a URL, using the Public Suffix List.";
    license = lib.licenses.bsd3;
  };

}
