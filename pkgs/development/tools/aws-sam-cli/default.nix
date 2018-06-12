{ lib
, python
}:

with python;

pkgs.buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "0.3.0";

  src = pkgs.fetchPypi {
    inherit pname version;
    sha256 = "7e7275a34e7e9d926198fd9516404310faa2a9681b7a8b0c8b2f9aa31aeb1bfb";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

  propagatedBuildInputs = with pkgs; [
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
