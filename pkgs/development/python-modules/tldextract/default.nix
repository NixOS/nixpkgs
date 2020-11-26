{ lib, fetchPypi, buildPythonPackage
, requests, requests-file, idna, pytest
, responses
}:

buildPythonPackage rec {
  pname   = "tldextract";
  version = "2.2.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "ab0e38977a129c72729476d5f8c85a8e1f8e49e9202e1db8dca76e95da7be9a8";
  };

  propagatedBuildInputs = [ requests requests-file idna ];
  checkInputs = [ pytest responses ];

  meta = {
    homepage = "https://github.com/john-kurkowski/tldextract";
    description = "Accurately separate the TLD from the registered domain and subdomains of a URL, using the Public Suffix List.";
    license = lib.licenses.bsd3;
  };

}
