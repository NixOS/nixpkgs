{ lib
, python3
, enableTelemetry ? false
}:

python3.pkgs.buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "1.26.0";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "11aqdwhs7wa6cp9zijqi4in3zvwirfnlcy45rrnsq0jdsh3i9hbh";
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
      --replace "click~=7.1" "click~=8.0" \
      --replace "Flask~=1.1.2" "Flask~=2.0" \
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
