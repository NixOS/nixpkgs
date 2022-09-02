{ lib
, python3
, enableTelemetry ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "1.53.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    hash = "sha256-kIW+aGYuS+JgOMsPbeLgPSgLFNKLSqHaZ1CHpjs/IVI=";
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
  ];

  postFixup = if enableTelemetry then "echo aws-sam-cli TELEMETRY IS ENABLED" else ''
    # Disable telemetry: https://github.com/awslabs/aws-sam-cli/issues/1272
    wrapProgram $out/bin/sam --set  SAM_CLI_TELEMETRY 0
  '';

  patches = [
    # Click 8.1 removed `get_terminal_size`, recommending
    # `shutil.get_terminal_size` instead.
    # (https://github.com/pallets/click/pull/2130)
    ./support-click-8-1.patch
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
    license = licenses.asl20;
    maintainers = with maintainers; [ lo1tuma ];
  };
}
