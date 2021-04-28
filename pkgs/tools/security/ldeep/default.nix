{ lib
, buildPythonApplication
, fetchPypi
, commandparse
, dnspython
, ldap3
, termcolor
, tqdm
}:

buildPythonApplication rec {
  pname = "ldeep";
  version = "1.0.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-MYVC8fxLW85n8uZVMhb2Zml1lQ8vW9gw/eRLcmemQx4=";
  };

  propagatedBuildInputs = [
    commandparse
    dnspython
    ldap3
    termcolor
    tqdm
  ];

  # no tests are present
  doCheck = false;
  pythonImportsCheck = [ "ldeep" ];

  meta = with lib; {
    description = "In-depth LDAP enumeration utility";
    homepage = "https://github.com/franc-pentest/ldeep";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
