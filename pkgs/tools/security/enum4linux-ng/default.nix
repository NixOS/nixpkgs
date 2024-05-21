{
  lib,
  fetchFromGitHub,
  python3,
  samba,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "enum4linux-ng";
  version = "1.3.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cddmp";
    repo = "enum4linux-ng";
    rev = "refs/tags/v${version}";
    hash = "sha256-VpNYgdgvsQG5UcxoyyLCj5ijJdIKKhCSqnHTvTgD4lA=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies =
    [ samba ]
    ++ (with python3.pkgs; [
      impacket
      ldap3
      pyyaml
    ]);

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
    mainProgram = "enum4linux-ng";
  };
}
