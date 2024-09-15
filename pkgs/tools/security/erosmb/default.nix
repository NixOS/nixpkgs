{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "erosmb";
  version = "0.1.5";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "viktor02";
    repo = "EroSmb";
    rev = "refs/tags/v${version}";
    hash = "sha256-9Zs5Z+3JiBiJkV9Ixl5pPmLv0dUT59CT0UkQDsmneWc=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    chardet
    colorama
    cryptography
    impacket
    ldap3
    ldapdomaindump
    pyasn1
    setuptools
    six
  ];

  # Project has no tests
  doCheck = false;

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck
    $out/bin/erosmb --help
    runHook postInstallCheck
  '';

  meta = with lib; {
    description = "SMB network scanner";
    homepage = "https://github.com/viktor02/EroSmb";
    changelog = "https://github.com/viktor02/EroSmb/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "erosmb";
  };
}
