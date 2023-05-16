{ lib
, python3
<<<<<<< HEAD
, fetchPypi
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, enableTelemetry ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aws-sam-cli";
<<<<<<< HEAD
  version = "1.90.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JXUfc37O6cTTOCTTtWE05m+GR4iDyBsmRPyXoTRxFmo=";
=======
  version = "1.53.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-kIW+aGYuS+JgOMsPbeLgPSgLFNKLSqHaZ1CHpjs/IVI=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  propagatedBuildInputs = with python3.pkgs; [
    aws-lambda-builders
    aws-sam-translator
<<<<<<< HEAD
    boto3
    cfn-lint
    chevron
    cookiecutter
    dateparser
    docker
    flask
    pyopenssl
    pyyaml
    rich
    ruamel-yaml
    serverlessrepo
    tomlkit
    typing-extensions
    tzlocal
    watchdog
=======
    chevron
    click
    cookiecutter
    dateparser
    python-dateutil
    docker
    flask
    jmespath
    requests
    serverlessrepo
    tomlkit
    watchdog
    typing-extensions
    regex
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  postFixup = if enableTelemetry then "echo aws-sam-cli TELEMETRY IS ENABLED" else ''
    # Disable telemetry: https://github.com/awslabs/aws-sam-cli/issues/1272
    wrapProgram $out/bin/sam --set  SAM_CLI_TELEMETRY 0
  '';

<<<<<<< HEAD
  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace 'PyYAML>=' 'PyYAML>=5.4.1 #' \
      --replace "aws_lambda_builders==" "aws_lambda_builders>=" \
      --replace 'aws-sam-translator==1.70.0' 'aws-sam-translator>=1.60.1' \
      --replace 'boto3>=' 'boto3>=1.26.79 #' \
      --replace 'cfn-lint~=0.77.9' 'cfn-lint~=0.73.2' \
      --replace "cookiecutter~=" "cookiecutter>=" \
      --replace 'docker~=6.1.0' 'docker~=6.0.1' \
      --replace 'ruamel_yaml~=0.17.32' 'ruamel_yaml~=0.17.21' \
      --replace 'tomlkit==0.11.8' 'tomlkit>=0.11.8' \
      --replace 'typing_extensions~=4.4.0' 'typing_extensions~=4.4' \
      --replace 'tzlocal==3.0' 'tzlocal>=3.0' \
      --replace 'watchdog==' 'watchdog>=2.1.2 #'
  '';

  doCheck = false;

  meta = with lib; {
    description = "CLI tool for local development and testing of Serverless applications";
    homepage = "https://github.com/awslabs/aws-sam-cli";
    changelog = "https://github.com/aws/aws-sam-cli/releases/tag/v${version}";
=======
  patches = [
    # Click 8.1 removed `get_terminal_size`, recommending
    # `shutil.get_terminal_size` instead.
    # (https://github.com/pallets/click/pull/2130)
    ./support-click-8-1.patch
    # Werkzeug >= 2.1.0 breaks the `sam local start-lambda` command because
    # aws-sam-cli uses a "WERKZEUG_RUN_MAIN" hack to suppress flask output.
    # (https://github.com/cs01/gdbgui/issues/425)
    ./use_forward_compatible_log_silencing.patch
  ];

  # fix over-restrictive version bounds
  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace "aws_lambda_builders==" "aws-lambda-builders #" \
      --replace "aws-sam-translator==1.46.0" "aws-sam-translator~=1.46" \
      --replace "click~=7.1" "click~=8.1" \
      --replace "cookiecutter~=1.7.2" "cookiecutter>=1.7.2" \
      --replace "dateparser~=1.0" "dateparser>=0.7" \
      --replace "docker~=4.2.0" "docker>=4.2.0" \
      --replace "Flask~=1.1.4" "Flask~=2.0" \
      --replace "jmespath~=0.10.0" "jmespath" \
      --replace "MarkupSafe==2.0.1" "MarkupSafe #" \
      --replace "PyYAML~=5.3" "PyYAML #" \
      --replace "regex==" "regex #" \
      --replace "requests==" "requests #" \
      --replace "typing_extensions==" "typing-extensions #" \
      --replace "tzlocal==3.0" "tzlocal #" \
      --replace "tomlkit==0.7.2" "tomlkit #" \
      --replace "watchdog==" "watchdog #"
  '';

  # Tests are not included in the PyPI package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-sam-cli";
    description = "CLI tool for local development and testing of Serverless applications";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.asl20;
    maintainers = with maintainers; [ lo1tuma ];
  };
}
