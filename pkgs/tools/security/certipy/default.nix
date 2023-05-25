{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "certipy";
  version = "4.4.0";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ly4k";
    repo = "Certipy";
    rev = "refs/tags/${version}";
    hash = "sha256-llLGr9IpuXQYIN2WaOkvfE2dAZb3PMVlNmketUpuyDI=";
  };

  postPatch = ''
    # pin does not apply because our ldap3 contains a patch to fix pyasn1 compability
    substituteInPlace setup.py \
      --replace "pyasn1==0.4.8" "pyasn1"
  '';

  propagatedBuildInputs = with python3.pkgs; [
    asn1crypto
    dnspython
    dsinternals
    impacket
    ldap3
    pyasn1
    pycryptodome
    requests_ntlm
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
