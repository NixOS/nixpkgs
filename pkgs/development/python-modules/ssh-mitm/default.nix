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
  version = "3.0.1";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-bFxpgzomtcFGf0LfLUR05y3+/8DNhND6EKAmCZcYb5E=";
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
