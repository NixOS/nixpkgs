{ lib, fetchPypi, buildPythonPackage
, requests, requests-file, idna, pytest
, responses
}:

buildPythonPackage rec {
  pname   = "tldextract";
  version = "2.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1d5s8v6kpsgazyahflhji1cfdcf89rv7l7z55v774bhzvcjp2y99";
  };

  propagatedBuildInputs = [ requests requests-file idna ];
  checkInputs = [ pytest responses ];

  meta = {
    homepage = https://github.com/john-kurkowski/tldextract;
    description = "Accurately separate the TLD from the registered domain and subdomains of a URL, using the Public Suffix List.";
    license = lib.licenses.bsd3;
  };

}
