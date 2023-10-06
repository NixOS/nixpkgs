{ lib, python3, fetchFromGitHub, glibcLocales, docker-compose_1, git }:
let
  docker_compose = changeVersion (with localPython.pkgs; docker-compose_1.override {
    inherit colorama pyyaml six dockerpty docker jsonschema requests websocket-client paramiko;
  }).overridePythonAttrs "1.25.5" "sha256-ei622Bc/30COUF5vfUl6wLd3OIcZVCvp5JoO/Ud6UMY=";

  changeVersion = overrideFunc: version: hash: overrideFunc (oldAttrs: rec {
    inherit version;
    src = oldAttrs.src.override {
      inherit version hash;
    };
  });

  localPython = python3.override
    {
      self = localPython;
      packageOverrides = self: super: {
        cement = changeVersion super.cement.overridePythonAttrs "2.8.2" "sha256-h2XtBSwGHXTk0Bia3cM9Jo3lRMohmyWdeXdB9yXkItI=";
        wcwidth = changeVersion super.wcwidth.overridePythonAttrs "0.1.9" "sha256-7nOGKGKhVr93/5KwkDT8SCXdOvnPgbxbNgZo1CXzxfE=";
        semantic-version = changeVersion super.semantic-version.overridePythonAttrs "2.8.5" "sha256-0sst4FWHYpNGebmhBOguynr0SMn0l00fPuzP9lHfilQ=";
      };
    };
in
with localPython.pkgs; buildPythonApplication rec {
  pname = "awsebcli";
  version = "3.20.9";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-elastic-beanstalk-cli";
    rev = "refs/tags/${version}";
    hash = "sha256-tnBDEeR+SCHb9UT3pTO7ISm4TVICvVfrV5cfz/60YQY=";
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
    docker_compose
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
  };
}
