{ lib
, python3
, fetchFromGitHub
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rotate-backups";
  version = "8.1";

  src = fetchFromGitHub {
    owner = "xolox";
    repo = "python-rotate-backups";
    rev = version;
    sha256 = "0r4dyd7hj403rksgp3vh1azp9n4af75r3wq3x39wxcqizpms3vkx";
  };

  propagatedBuildInputs = with python3.pkgs; [
    python-dateutil
    simpleeval
    update-dotdee
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  disabledTests = [
    # https://github.com/xolox/python-rotate-backups/issues/33
    "test_removal_command"
  ];

  meta = with lib; {
    description = "Simple command line interface for backup rotation";
    mainProgram = "rotate-backups";
    homepage = "https://github.com/xolox/python-rotate-backups";
    license = licenses.mit;
    maintainers = with maintainers; [ eyjhb ];
  };
}
