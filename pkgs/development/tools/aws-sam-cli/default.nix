{ lib
, python3
, enableTelemetry ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "1.78.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-zfNW0Uuo0w+JXkBdpErqLJIpGRlbrpWSrNYruRbSKS8=";
  };

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
    cfn-lint
    ruamel-yaml
    pyopenssl
  ];

  postFixup = if enableTelemetry then "echo aws-sam-cli TELEMETRY IS ENABLED" else ''
    # Disable telemetry: https://github.com/awslabs/aws-sam-cli/issues/1272
    wrapProgram $out/bin/sam --set  SAM_CLI_TELEMETRY 0
  '';

  patches = [
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
      --replace "Flask<2.1" "Flask #" \
      --replace "jmespath~=0.10.0" "jmespath" \
      --replace "MarkupSafe==2.0.1" "MarkupSafe #" \
      --replace "PyYAML>=5.4.1,==5.*" "PyYAML #" \
      --replace "regex==" "regex #" \
      --replace "requests==" "requests #" \
      --replace "typing_extensions~=" "typing-extensions #" \
      --replace "cfn-lint~=" "cfn-lint #" \
      --replace "tzlocal==3.0" "tzlocal #" \
      --replace "tomlkit==0.7.2" "tomlkit #" \
      --replace "watchdog==" "watchdog #"
  '';

  # Tests are not included in the PyPI package
  doCheck = false;

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-sam-cli";
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ lo1tuma ];
  };
}
