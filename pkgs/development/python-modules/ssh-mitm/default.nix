{ lib
, argcomplete
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
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
  version = "3.0.2";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-koV7g6ZmrrXk60rrDP8BwrDZk3shiyJigQgNcb4BASE=";
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
    changelog = "https://github.com/ssh-mitm/ssh-mitm/blob/${version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
