{ lib
, buildPythonPackage
, fetchPypi
, filelock
, idna
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, requests-file
, responses
, setuptools-scm
}:

buildPythonPackage rec {
  pname   = "tldextract";
  version = "3.1.0";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "cfae9bc8bda37c3e8c7c8639711ad20e95dc85b207a256b60b0b23d7ff5540ea";
  };

  nativeBuildInputs = [ setuptools-scm ];

  propagatedBuildInputs = [
    filelock
    idna
    requests
    requests-file
  ];

  checkInputs = [
    pytest-mock
    pytestCheckHook
    responses
  ];

  postPatch = ''
    substituteInPlace pytest.ini --replace " --pylint" ""
  '';

  pythonImportsCheck = [ "tldextract" ];

  meta = with lib; {
    description = "Python module to accurately separate the TLD from the domain of an URL";
    longDescription = ''
      tldextract accurately separates the gTLD or ccTLD (generic or country code top-level domain)
      from the registered domain and subdomains of a URL.
    '';
    homepage = "https://github.com/john-kurkowski/tldextract";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
