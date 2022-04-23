{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "winacl";
  version = "0.1.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-G6xWep0hMACCqiJGuw+UpZH8qOIY4WO6sY3w4y7v6gY=";
  };

  # Project doesn't have tests
  doCheck = false;
  pythonImportsCheck = [ "winacl" ];

  meta = with lib; {
    description = "Python module for ACL/ACE/Security descriptor manipulation";
    homepage = "https://github.com/skelsec/winacl";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
