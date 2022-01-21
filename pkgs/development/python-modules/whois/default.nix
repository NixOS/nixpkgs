{ lib
, buildPythonPackage
, fetchFromGitHub
, inetutils
}:

buildPythonPackage rec {
  pname = "whois";
  version = "0.9.14";

  src = fetchFromGitHub {
    owner = "DannyCork";
    repo = "python-whois";
    rev = version;
    sha256 = "1df4r2pr356y1c2ys6pzdl93fmx9ci4y75xphc95xn27zvqbpvix";
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
