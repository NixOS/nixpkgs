{
  lib,
  fetchFromGitHub,
  python3,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smbmap";
  version = "1.10.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ShawnDEvans";
    repo = "smbmap";
    rev = "refs/tags/v${version}";
    hash = "sha256-ZzNiNAGf0FYfo3Zow4crWFQQb4+GhUeHpwJfuM5P9Ds=";
  };

  build-system = with python3.pkgs; [ setuptools ];

  dependencies = with python3.pkgs; [
    impacket
    pyasn1
    pycrypto
    configparser
    termcolor
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "smbmap" ];

  meta = with lib; {
    description = "SMB enumeration tool";
    homepage = "https://github.com/ShawnDEvans/smbmap";
    changelog = "https://github.com/ShawnDEvans/smbmap/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
    mainProgram = "smbmap";
  };
}
