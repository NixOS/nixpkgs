{ lib
, python
}:

let
  py = python.override {
    packageOverrides = self: super: {
      click = super.click.overridePythonAttrs (oldAttrs: rec {
        version = "6.7";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "f15516df478d5a56180fbf80e68f206010e6d160fc39fa508b65e035fd75130b";
        };
      });

      requests = super.requests.overridePythonAttrs (oldAttrs: rec {
        version = "2.20.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "ea881206e59f41dbd0bd445437d792e43906703fff75ca8ff43ccdb11f33f263";
        };
      });

      idna = super.idna.overridePythonAttrs (oldAttrs: rec {
        version = "2.7";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "684a38a6f903c1d71d6d5fac066b58d7768af4de2b832e426ec79c30daa94a16";
        };
      });

      six = super.six.overridePythonAttrs (oldAttrs: rec {
        version = "1.11";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "70e8a77beed4562e7f14fe23a786b54f6296e34344c23bc42f07b15018ff98e9";
        };
      });
    };
  };

in

with py.pkgs;

buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "0.14.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "b7f80838d57c1096a9a03ed703a91a8a5775a6ead33df8f31765ecf39b3a956f";
  };

  # Tests are not included in the PyPI package
  doCheck = false;

  propagatedBuildInputs = [
    aws-lambda-builders
    aws-sam-translator
    chevron
    click
    cookiecutter
    dateparser
    docker
    flask
    idna
    pathlib2
    requests
    serverlessrepo
    six
  ];

  meta = with lib; {
    homepage = https://github.com/awslabs/aws-sam-cli;
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ andreabedini dhkl ];
  };
}
