{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
}:

buildPythonPackage rec {
  pname = "winacl";
  version = "0.1.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-G6xWep0hMACCqiJGuw+UpZH8qOIY4WO6sY3w4y7v6gY=";
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
