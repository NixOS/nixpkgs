{ lib
, python3
, enableTelemetry ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "1.35.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-ojJoC8UuZDVm6CDmYbPoO0e+1QAYa0UcekYEd/MGFRM=";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

  propagatedBuildInputs = with python3.pkgs; [
    aws-lambda-builders
    aws-sam-translator
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
  ];

  postFixup = if enableTelemetry then "echo aws-sam-cli TELEMETRY IS ENABLED" else ''
    # Disable telemetry: https://github.com/awslabs/aws-sam-cli/issues/1272
    wrapProgram $out/bin/sam --set  SAM_CLI_TELEMETRY 0
  '';

  # fix over-restrictive version bounds
  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace "click~=7.1" "click~=8.0" \
      --replace "Flask~=1.1.2" "Flask~=2.0" \
      --replace "dateparser~=1.0" "dateparser>=0.7" \
      --replace "docker~=4.2.0" "docker>=4.2.0" \
      --replace "requests==" "requests #" \
      --replace "watchdog==" "watchdog #" \
      --replace "aws_lambda_builders==" "aws-lambda-builders #" \
      --replace "typing_extensions==" "typing-extensions #" \
      --replace "regex==" "regex #" \
      --replace "tzlocal==3.0" "tzlocal==2.*"
  '';

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-sam-cli";
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ lo1tuma ];
  };
}
