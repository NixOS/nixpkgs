{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smbmap";
  version = "unstable-2023-03-29";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ShawnDEvans";
    repo = "smbmap";
    rev = "ce60773320e11b2ecd1ce1b5ab2a62d43d4a4423";
    hash = "sha256-4DdiICH3B7x8Wr5CcqiuhCHPv6W/5bT5MGdXkyE0OKA=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    impacket
    pyasn1
    pycrypto
    configparser
    termcolor
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [
    "smbmap"
  ];

  meta = with lib; {
    description = "SMB enumeration tool";
    homepage = "https://github.com/ShawnDEvans/smbmap";
    changelog = "https://github.com/ShawnDEvans/smbmap/releases/tag/v${version}";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
