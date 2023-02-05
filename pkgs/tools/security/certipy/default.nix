{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "certipy";
  version = "2.0.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ly4k";
    repo = "Certipy";
    rev = "refs/tags/${version}";
    hash = "sha256-84nGRKZ0UlMDAZ1Wo5Hgy9XSAyEh0Tio9+3OZVFZG5k=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    asn1crypto
    dnspython
    dsinternals
    impacket
    ldap3
    pyasn1
    pycryptodome
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "certipy"
  ];

  meta = with lib; {
    description = "Tool to enumerate and abuse misconfigurations in Active Directory Certificate Services";
    homepage = "https://github.com/ly4k/Certipy";
    changelog = "https://github.com/ly4k/Certipy/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
