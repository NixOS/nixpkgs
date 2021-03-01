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
  version = "1.0.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n38idkn9hy31m5xkrc36dmw364d137c7phssvj76gr2gqsrqjy3";
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
