{ lib
, buildPythonPackage
, fetchPypi
}:

buildPythonPackage rec {
  pname = "winacl";
  version = "0.1.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-V+W0WRtL4rJD1LeYgr0PtiKdWTDQYv2ulB1divaqKe4=";
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
