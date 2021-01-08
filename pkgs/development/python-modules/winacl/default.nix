{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "winacl";
  version = "0.1.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "05xhdhbvzs1hcd8lxmdr9mpr6ifx5flhlvk6jr0qi6h25imhqclp";
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
