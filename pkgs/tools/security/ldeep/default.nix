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
  version = "1.0.34";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-0fLaef/3SJgoBlXS0/ocauE1gjlvSlIc25RcLKl3O5g=";
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
