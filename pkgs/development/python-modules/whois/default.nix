{ lib
, buildPythonPackage
, fetchFromGitHub
, inetutils
, pythonOlder
}:

buildPythonPackage rec {
  pname = "whois";
  version = "0.9.15";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DannyCork";
    repo = "python-whois";
    rev = "refs/tags/${version}";
    sha256 = "sha256-Pfogvo0s678KHO85r4yopEaL4n/2cIY1+CnQu3iB8xc=";
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
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
