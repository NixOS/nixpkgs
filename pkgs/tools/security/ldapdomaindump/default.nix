{ lib
, buildPythonApplication
, fetchPypi
, dnspython
, future
, ldap3
}:

buildPythonApplication rec {
  pname = "ldapdomaindump";
  version = "0.9.3";

  src = fetchPypi {
    inherit pname;
    inherit version;
    sha256 = "10cis8cllpa9qi5qil9k7521ag3921mxwg2wj9nyn0lk41rkjagc";
  };

  propagatedBuildInputs = [
    dnspython
    future
    ldap3
  ];

  # no tests are present
  doCheck = false;

  pythonImportsCheck = [ "ldapdomaindump" ];

  meta = with lib; {
    description = "Tool for dumping Active Directory information";
    longDescription = ''
      ldapdomaindump is a tool which aims to solve this problem, by collecting
      and parsing information available via LDAP and outputting it in a human
      readable HTML format, as well as machine readable JSON and csv/tsv/
      greppable files.
    '';
    homepage = "https://github.com/dirkjanm/ldapdomaindump";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
