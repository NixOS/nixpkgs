{ lib
, python3
, enableTelemetry ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "1.23.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "0j0q6p08c3l9z0yc2cggw797k47cjh6ljpchiqgg0fh6mk32215f";
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
  ];

  postFixup = if enableTelemetry then "echo aws-sam-cli TELEMETRY IS ENABLED" else ''
    # Disable telemetry: https://github.com/awslabs/aws-sam-cli/issues/1272
    wrapProgram $out/bin/sam --set  SAM_CLI_TELEMETRY 0
  '';

  # fix over-restrictive version bounds
  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace "dateparser~=0.7" "dateparser>=0.7" \
      --replace "docker~=4.2.0" "docker>=4.2.0" \
      --replace "requests==2.23.0" "requests~=2.24" \
      --replace "watchdog==0.10.3" "watchdog"
  '';

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-sam-cli";
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ lo1tuma ];
  };
}
