{ lib
, buildPythonPackage
, fetchFromGitHub
, inetutils
, pythonOlder
}:

buildPythonPackage rec {
  pname = "whois";
  version = "0.9.25";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DannyCork";
    repo = "python-whois";
    rev = "refs/tags/${version}";
    hash = "sha256-h4s0cJbzc5uorT9yPtXIgVDwUExUe3cNMSHCWRhN1Q4=";
  };

  propagatedBuildInputs = [
    # whois is needed
    inetutils
  ];

  # tests require network access
  doCheck = false;

  pythonImportsCheck = [
    "whois"
  ];

  meta = with lib; {
    description = "Python module/library for retrieving WHOIS information";
    homepage = "https://github.com/DannyCork/python-whois/";
    changelog = "https://github.com/DannyCork/python-whois/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
