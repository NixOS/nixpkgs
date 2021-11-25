{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "certipy";
  version = "unstable-2021-11-08";

  src = fetchFromGitHub {
    owner = "ly4k";
    repo = "Certipy";
    rev = "c2f5581505c54f3bf9fe4e6f07c17fa9ef501cab";
    sha256 = "0m2n30prqd9d02kmryk8vry4cabcad1892qr8a02qfg6r98x8q3q";
  };

  propagatedBuildInputs = with python3.pkgs; [
    asn1crypto
    pycryptodome
    impacket
    ldap3
    pyasn1
    dnspython
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "certipy"
  ];

  meta = with lib; {
    description = "Tool to enumerate and abuse misconfigurations in Active Directory Certificate Services";
    homepage = "https://github.com/ly4k/Certipy";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
