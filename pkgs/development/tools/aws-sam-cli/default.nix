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

      aws-sam-translator = super.aws-sam-translator.overridePythonAttrs (oldAttrs: rec {
        version = "1.10.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0e1fa094c6791b233f5e73f2f0803ec6e0622f2320ec5a969f0986855221b92b";
        };
      });
    };
  };

in

with py.pkgs;

buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "0.16.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2dd68800723c76f52980141ba704e105d77469b6ba465781fbc9120e8121e76c";
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

  postPatch = ''
    substituteInPlace requirements/base.txt --replace "requests==2.20.1" "requests==2.22.0"
    substituteInPlace requirements/base.txt --replace "six~=1.11.0" "six~=1.12.0"
    substituteInPlace requirements/base.txt --replace "PyYAML~=3.12" "PyYAML~=5.1"
  '';

  meta = with lib; {
    homepage = https://github.com/awslabs/aws-sam-cli;
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ andreabedini dhkl ];
  };
}
