{ lib
, python
}:

with python.pkgs;

buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "0.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "523cd125bd89cd1d42559101a8500f74f88067fd9b26f72b1d05c5d00a76bed9";
  };

   # Tests are not included in the PyPI package
  doCheck = false;

  propagatedBuildInputs = [
    aws-sam-translator
    six
    chevron
    click
    flask
    boto3
    click
    pyyaml
    cookiecutter
    aws-sam-translator
    dateparser
    docker
    python-dateutil
    requests
    aws-lambda-builders
    serverlessrepo
    enum34
    flask
    python-dateutil
    pyyaml
    six
    pathlib2
  ];

  postPatch = ''
    substituteInPlace ./requirements/base.txt --replace 'click~=6.7' 'click>=6.7';
    substituteInPlace ./requirements/base.txt --replace 'serverlessrepo==0.1.5' 'serverlessrepo>=0.1.5';
  '';

  meta = with lib; {
    homepage = https://github.com/awslabs/aws-sam-cli;
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ andreabedini ];
  };
}
