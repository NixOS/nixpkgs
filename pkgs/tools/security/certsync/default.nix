{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "certsync";
  version = "unstable-2023-04-14";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "zblurx";
    repo = "certsync";
    rev = "f3c8b61f0967a6403d4c592dcbfa8921682452a6";
    hash = "sha256-7Pzss83jf3zKmgQZki18R47OWn5VniZZ/d4N8JgZs+0=";
  };

  nativeBuildInputs = with python3.pkgs; [
    poetry-core
  ];

  propagatedBuildInputs = with python3.pkgs; [
    certipy-ad
    tqdm
  ];

  pythonImportsCheck = [
    "certsync"
  ];

  meta = with lib; {
    description = "Dump NTDS with golden certificates and UnPAC the hash";
    homepage = "https://github.com/zblurx/certsync";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
