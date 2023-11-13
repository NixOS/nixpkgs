{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smbmap";
  version = "1.9.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ShawnDEvans";
    repo = "smbmap";
    rev = "refs/tags/v${version}";
    hash = "sha256-NsxmH1W5VUckGvqqTIrxhaVz0l7gsHmc8KJuvC/iVbA=";
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
