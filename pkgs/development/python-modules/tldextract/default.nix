{ lib, fetchPypi, buildPythonPackage, setuptools_scm
, requests, requests-file, idna, filelock, pytest
, responses
}:

buildPythonPackage rec {
  pname   = "tldextract";
  version = "3.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfae9bc8bda37c3e8c7c8639711ad20e95dc85b207a256b60b0b23d7ff5540ea";
  };

  propagatedBuildInputs = [ requests requests-file idna filelock ];
  checkInputs = [ pytest responses ];
  nativeBuildInputs = [ setuptools_scm ];

  # No tests included
  doCheck = false;
  pythonImportsCheck = [ "tldextract" ];

  meta = {
    homepage = "https://github.com/john-kurkowski/tldextract";
    description = "Accurately separate the TLD from the registered domain and subdomains of a URL, using the Public Suffix List";
    license = lib.licenses.bsd3;
  };
}
