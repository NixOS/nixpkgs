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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "cddmp";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j6qrhrzc4f9crbii4dpgxipngjh5icrhljxf26a7662dd4f7l8q";
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
    license = with licenses; [ gpl3Plus ];
    maintainers = with maintainers; [ fab ];
  };
}
