{ lib
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, inetutils
}:

buildPythonPackage rec {
  pname = "whois";
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "DannyCork";
    repo = "python-whois";
    rev = version;
    sha256 = "1rbc4xif4dn455vc8dhxdvwszrb0nik5q9fy12db6mxfx6zikb7z";
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
