{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, argcomplete
, colored
, packaging
, paramiko
, pytz
, pyyaml
, rich
, sshpubkeys
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ssh-mitm";
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-DMXzDgSt1p3ZNGrXnSr79KH33SJNN8U4/94Hoz7Rs+I=";
  };

  propagatedBuildInputs = [
    argcomplete
    colored
    packaging
    paramiko
    pytz
    pyyaml
    rich
    sshpubkeys
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "sshmitm"
  ];

  meta = with lib; {
    description = "Tool for SSH security audits";
    homepage = "https://github.com/ssh-mitm/ssh-mitm";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
