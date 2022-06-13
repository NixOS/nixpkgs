{ lib
, buildPythonPackage
, fetchFromGitHub
, pythonOlder
, colored
, enhancements
, packaging
, paramiko
, pytz
, pyyaml
, requests
, rich
, sshpubkeys
, typeguard
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "ssh-mitm";
  version = "2.0.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = pname;
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-F7+odIWiEy7Aea+Jnx5VuDv5PdMlvxX975QmlLQ5APE=";
  };

  propagatedBuildInputs = [
    colored
    enhancements
    packaging
    paramiko
    pytz
    pyyaml
    requests
    rich
    sshpubkeys
    typeguard
  ];

  # Module has no tests
  doCheck = false;

  pythonImportsCheck = [
    "sshmitm"
  ];

  meta = with lib; {
    description = "Tool for SSH security audits";
    homepage = "https://github.com/ssh-mitm/ssh-mitm";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ fab ];
  };
}
