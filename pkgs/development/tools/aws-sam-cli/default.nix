{ lib
, python3
, fetchPypi
, enableTelemetry ? false
, testers
, aws-sam-cli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "1.98.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-T7Tywkzrf7htXbJccUzLxfQPp6Kk9mQgI5ZlPOOmOX4=";
  };

  pythonRelaxDeps = [
    "aws-lambda-builders"
    "aws-sam-translator"
    "boto3"
    "cfn-lint"
    "click"
    "docker"
    "jsonschema"
    "rich"
    "click"
    "tomlkit"
    "tzlocal"
    "watchdog"
  ];

  propagatedBuildInputs = with python3.pkgs; [
    aws-lambda-builders
    aws-sam-translator
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
    click
    ruamel-yaml
    serverlessrepo
    tomlkit
    typing-extensions
    tzlocal
    watchdog
  ];

  postFixup = if enableTelemetry then "echo aws-sam-cli TELEMETRY IS ENABLED" else ''
    # Disable telemetry: https://github.com/awslabs/aws-sam-cli/issues/1272
    wrapProgram $out/bin/sam --set  SAM_CLI_TELEMETRY 0
  '';

  doCheck = false;

  passthru = {
    tests.version = testers.testVersion {
      package = aws-sam-cli;
      command = "sam --version";
    };
  };

  meta = with lib; {
    description = "CLI tool for local development and testing of Serverless applications";
    homepage = "https://github.com/awslabs/aws-sam-cli";
    changelog = "https://github.com/awslabs/aws-sam-cli/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ lo1tuma ];
  };
}
