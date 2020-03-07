{ lib, fetchPypi, buildPythonPackage
, requests, requests-file, idna, pytest
, responses
}:

buildPythonPackage rec {
  pname   = "tldextract";
  version = "2.2.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9aa21a1f7827df4209e242ec4fc2293af5940ec730cde46ea80f66ed97bfc808";
  };

  propagatedBuildInputs = [ requests requests-file idna ];
  checkInputs = [ pytest responses ];

  meta = {
    homepage = https://github.com/john-kurkowski/tldextract;
    description = "Accurately separate the TLD from the registered domain and subdomains of a URL, using the Public Suffix List.";
    license = lib.licenses.bsd3;
  };

}
