{ lib
, python
}:

with python.pkgs;

buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4740bfa23f39880d807aa75a2143259f7f15eec34c5fa5dde8fc04d8563ef521";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

  propagatedBuildInputs = [
    aws-sam-translator
    boto3
    click
    cookiecutter
    docker
    enum34
    flask
    pyyaml
    six
  ];

  meta = with lib; {
    homepage = https://github.com/awslabs/aws-sam-cli;
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ andreabedini ];
  };
}
