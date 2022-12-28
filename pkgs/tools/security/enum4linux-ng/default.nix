{ lib
, buildPythonApplication
, fetchFromGitHub
, impacket
, ldap3
, pyyaml
, samba
}:

buildPythonApplication rec {
  pname = "enum4linux-ng";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "cddmp";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-InE0VRk9hK7JEKL202/2RclrJHAHFAol3DxKnVA+lq4=";
  };

  propagatedBuildInputs = [
    impacket
    ldap3
    pyyaml
    samba
  ];

  # It's only a script and not a Python module. Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Windows/Samba enumeration tool";
    longDescription = ''
      enum4linux-ng.py is a rewrite of Mark Lowe's enum4linux.pl, a tool for
      enumerating information from Windows and Samba systems.
    '';
    homepage = "https://github.com/cddmp/enum4linux-ng";
    changelog = "https://github.com/cddmp/enum4linux-ng/releases/tag/v${version}";
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
