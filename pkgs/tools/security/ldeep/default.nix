{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "ldeep";
  version = "1.0.52";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "franc-pentest";
    repo = "ldeep";
    rev = "refs/tags/${version}";
    hash = "sha256-I51vz3zF1J3223hcO3cdfsNBfpq/UolDxUEXyqx3dLI=";
  };

  pythonRelaxDeps = [
    "cryptography"
  ];

  nativeBuildInputs = with python3.pkgs; [
    cython
    pythonRelaxDepsHook
    setuptools
  ];

  propagatedBuildInputs = with python3.pkgs; [
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

  # no tests are present
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
  };
}
