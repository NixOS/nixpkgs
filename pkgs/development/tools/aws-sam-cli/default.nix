{ lib
, python3
, fetchPypi
, enableTelemetry ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "1.90.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JXUfc37O6cTTOCTTtWE05m+GR4iDyBsmRPyXoTRxFmo=";
  };

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
    license = licenses.asl20;
    maintainers = with maintainers; [ lo1tuma ];
  };
}
