{ lib
, buildPythonPackage
, fetchFromGitHub
, inetutils
, pythonOlder
}:

buildPythonPackage rec {
  pname = "whois";
  version = "0.9.16";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "DannyCork";
    repo = "python-whois";
    rev = "refs/tags/${version}";
    sha256 = "sha256-tpgRBTA+0c0F5XA+dusqPHlegV5r2Ny7AZeRBvS1pcQ=";
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
