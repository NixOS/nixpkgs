{ lib
, fetchFromGitHub
, john
, python3
}:

python3.pkgs.buildPythonApplication {
  pname = "adenum";
  version = "unstable-2022-04-01";
  format = "other";

  src = fetchFromGitHub {
    owner = "SecuProject";
    repo = "ADenum";
    rev = "0e3576eca1d987d3ef22d53fc725189bb301e804";
    hash = "sha256-8s4Kmt4ZjYbQGGVDWKfuRZ6kthcL8FiQytoq9Koy7Kc=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    pwntools
    python-ldap
  ] ++ [
    john
  ];

  installPhase = ''
    runHook preInstall

    # Add shebang so we can patch it
    sed -i -e '1i#!/usr/bin/python' ADenum.py
    patchShebangs ADenum.py
    install -vD ADenum.py $out/bin/adenum

    runHook postInstall
  '';

  # Project has no tests
  doCheck = false;

  meta = with lib; {
    description = "Tool to find misconfiguration through LDAP";
    homepage = "https://github.com/SecuProject/ADenum";
    license = with licenses; [ gpl3Only ];
    maintainers = with maintainers; [ fab ];
  };
}
