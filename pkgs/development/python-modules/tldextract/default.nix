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
  version = "3.1.2";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0gNMNVhlH32P2t6oP7aBBQstZi3GegDZUDJtyQIClEQ=";
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
