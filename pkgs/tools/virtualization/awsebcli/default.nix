{ lib, python3, fetchFromGitHub, glibcLocales, git }:
let
  changeVersion = overrideFunc: version: hash: overrideFunc (oldAttrs: rec {
    inherit version;
    src = oldAttrs.src.override {
      inherit version hash;
    };
  });

  localPython = python3.override {
    self = localPython;
    packageOverrides = self: super: {
      cement = changeVersion super.cement.overridePythonAttrs "2.8.2" "sha256-h2XtBSwGHXTk0Bia3cM9Jo3lRMohmyWdeXdB9yXkItI=";
    };
  };
in
with localPython.pkgs; buildPythonApplication rec {
  pname = "awsebcli";
  version = "3.20.10";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-elastic-beanstalk-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-4JZx0iTMyrPHbuS3zlhpiWnenAQO5eSBJbPHUizLhYo=";
  };

  postPatch = ''
    # https://github.com/aws/aws-elastic-beanstalk-cli/pull/469
    substituteInPlace setup.py --replace "scripts=['bin/eb']," ""
  '';

  nativeBuildInputs = [
    pythonRelaxDepsHook
  ];

  buildInputs = [
    glibcLocales
  ];

  propagatedBuildInputs = [
    blessed
    botocore
    cement
    colorama
    pathspec
    pyyaml
    future
    requests
    semantic-version
    setuptools
    tabulate
    termcolor
    websocket-client
  ];

  pythonRelaxDeps = [
    "botocore"
    "colorama"
    "pathspec"
    "PyYAML"
    "six"
    "termcolor"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-socket
    mock
    git
  ];

  pytestFlagsArray = [
    "tests/unit"
  ];

  disabledTests = [
    # Needs docker installed to run.
    "test_local_run"
    "test_local_run__with_arguments"

    # Needs access to the user's ~/.ssh directory.
    "test_generate_and_upload_keypair__exit_code_0"
    "test_generate_and_upload_keypair__exit_code_1"
    "test_generate_and_upload_keypair__exit_code_is_other_than_1_and_0"
    "test_generate_and_upload_keypair__ssh_keygen_not_present"
  ];

  meta = with lib; {
    homepage = "https://aws.amazon.com/elasticbeanstalk/";
    description = "A command line interface for Elastic Beanstalk";
    changelog = "https://github.com/aws/aws-elastic-beanstalk-cli/blob/${version}/CHANGES.rst";
    maintainers = with maintainers; [ eqyiel kirillrdy ];
    license = licenses.asl20;
    mainProgram = "eb";
  };
}
