{ lib
, buildPythonPackage
, fetchFromGitHub
, filelock
, idna
, pytest-mock
, pytestCheckHook
, pythonOlder
, requests
, requests-file
, responses
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "tldextract";
  version = "5.1.1";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "john-kurkowski";
    repo = "tldextract";
    rev = "refs/tags/${version}";
    hash = "sha256-/VBbU8FuB8MEuX6MgGO44+gfqVjl1aHHDHncHY2Jo38=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    filelock
    idna
    requests
    requests-file
  ];

  nativeCheckInputs = [
    pytest-mock
    pytestCheckHook
    responses
  ];

  pythonImportsCheck = [
    "tldextract"
  ];

  meta = with lib; {
    description = "Python module to accurately separate the TLD from the domain of an URL";
    longDescription = ''
      tldextract accurately separates the gTLD or ccTLD (generic or country code top-level domain)
      from the registered domain and subdomains of a URL.
    '';
    homepage = "https://github.com/john-kurkowski/tldextract";
    changelog = "https://github.com/john-kurkowski/tldextract/blob/${version}/CHANGELOG.md";
    license = with licenses; [ bsd3 ];
    maintainers = with maintainers; [ fab ];
  };
}
