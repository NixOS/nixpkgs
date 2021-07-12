{ lib
, buildPythonPackage
, fetchFromGitHub
, inetutils
}:

buildPythonPackage rec {
  pname = "whois";
  version = "0.9.13";

  src = fetchFromGitHub {
    owner = "DannyCork";
    repo = "python-whois";
    rev = version;
    sha256 = "0y2sfs6nkr2j2crrn81wkfdzn9aphb3iaddya5zd2midlgdqq7bw";
  };

  # whois is needed
  propagatedBuildInputs = [ inetutils ];

  # tests require network access
  doCheck = false;
  pythonImportsCheck = [ "whois" ];

  meta = with lib; {
    description = "Python module/library for retrieving WHOIS information";
    homepage = "https://github.com/DannyCork/python-whois/";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
