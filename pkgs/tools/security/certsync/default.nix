{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "certsync";
  version = "1.5-unstable-2024-03-08";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "zblurx";
    repo = "certsync";
    rev = "712e34c54a63537efd630561aa55dc9d35962c3f";
    hash = "sha256-YkxEExeu3sBJ93WJGtU5oe3rDS0Ki88vAeGpE23xRwo=";
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
    mainProgram = "certsync";
  };
}
