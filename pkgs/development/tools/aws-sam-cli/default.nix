{ lib
, python
}:

with python.pkgs;

buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "0.5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2acf9517f467950adb4939746658091e60cf60ee80093ffd0d3d821cb8a1f9fc";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

  propagatedBuildInputs = [
    aws-sam-translator
    boto3
    click
    cookiecutter
    dateparser
    docker
    enum34
    flask
    python-dateutil
    pyyaml
    six
  ];

  postPatch = ''
    substituteInPlace ./requirements/base.txt \
      --replace 'aws-sam-translator==1.6.0' 'aws-sam-translator>=1.6.0';
  '';

  meta = with lib; {
    homepage = https://github.com/awslabs/aws-sam-cli;
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ andreabedini ];
  };
}
