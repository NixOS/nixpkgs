{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "smbmap";
  version = "1.9.2";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "ShawnDEvans";
    repo = "smbmap";
    rev = "refs/tags/v${version}";
    hash = "sha256-n0cLj1K9Xt/1TlHOh9Kp/xIXYaUhmGSxrHL/yxDbfk4=";
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
