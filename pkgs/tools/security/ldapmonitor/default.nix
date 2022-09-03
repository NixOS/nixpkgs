{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ldapmonitor";
  version = "1.3";
  format = "other";

  src = fetchFromGitHub {
    owner = "p0dalirius";
    repo = pname;
    rev = version;
    hash = "sha256-lwTXvrnOVodCUQtR8FmCXiPuZ1Wx1ySfDKghpLXNuI4=";
  };

  sourceRoot = "${src.name}/python";

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    ldap
    ldap3
  ];

  installPhase = ''
    runHook preInstall

    install -vD pyLDAPmonitor.py $out/bin/ldapmonitor

    runHook postInstall
  '';

  meta = with lib; {
    description = "Tool to monitor creation, deletion and changes to LDAP objects";
    homepage = "https://github.com/p0dalirius/LDAPmonitor";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
