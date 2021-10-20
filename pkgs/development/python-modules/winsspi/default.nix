{ lib
, buildPythonPackage
, fetchPypi
, minikerberos
, pythonAtLeast
}:

buildPythonPackage rec {
  pname = "winsspi";
  version = "0.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1q8hr8l8d9jxyp55qsrlkyhdhqjc0n18ajzms7hf1xkhdl7rrbd2";
  };
  propagatedBuildInputs = [ minikerberos ];

  # Project doesn't have tests
  doCheck = false;
  pythonImportsCheck = [ "winsspi" ];

  meta = with lib; {
    description = "Python module for ACL/ACE/Security descriptor manipulation";
    homepage = "https://github.com/skelsec/winsspi";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
