{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ldeep";
  version = "1.0.53";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "franc-pentest";
    repo = "ldeep";
    rev = "refs/tags/${version}";
    hash = "sha256-67jVpzvdjEcjFmTRE2YjPr4AO1iN+PakwoKcjvimt8g=";
  };

  pythonRelaxDeps = [
    "cryptography"
  ];

  build-system = with python3.pkgs; [
    cython
    pythonRelaxDepsHook
    setuptools
  ];

  dependencies = with python3.pkgs; [
    commandparse
    cryptography
    dnspython
    gssapi
    ldap3
    oscrypto
    pycryptodome
    pycryptodomex
    six
    termcolor
    tqdm
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "ldeep"
  ];

  meta = with lib; {
    description = "In-depth LDAP enumeration utility";
    homepage = "https://github.com/franc-pentest/ldeep";
    changelog = "https://github.com/franc-pentest/ldeep/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
    mainProgram = "ldeep";
  };
}
