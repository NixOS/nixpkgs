{ lib
, buildPythonPackage
, fetchFromGitHub
, requests
, urllib3
}:

buildPythonPackage rec {
  pname = "unifiled";
  version = "1.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "florisvdk";
    repo = pname;
    rev = "v${version}";
    sha256 = "1nmqxxhwa0isxdb889nhbp7w4axj1mcrwd3pr9d8nhpw4yj9h3vq";
  };

  propagatedBuildInputs = [
    requests
    urllib3
  ];

  # Project doesn't have any tests
  doCheck = false;
  pythonImportsCheck = [ "unifiled" ];

  meta = with lib; {
    description = "Python module for Ubiquiti Unifi LED controller";
    homepage = "https://github.com/florisvdk/unifiled";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
