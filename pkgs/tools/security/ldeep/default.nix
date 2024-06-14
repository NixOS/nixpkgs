{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ldeep";
  version = "1.0.57";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "franc-pentest";
    repo = "ldeep";
    rev = "refs/tags/${version}";
    hash = "sha256-RjPpxKbZ9QK+dPe3Vj2IG2gr5ROtLLnVaHI3CdNwJpE=";
  };

  pythonRelaxDeps = [
    "cryptography"
  ];

  build-system = with python3.pkgs; [
    pdm-backend
  ];

  nativeBuildInputs = with python3.pkgs; [
    cython
    pythonRelaxDepsHook
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
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "ldeep";
  };
}
