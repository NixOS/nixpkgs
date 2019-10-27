{ lib
, python
}:

let
  py = python.override {
    packageOverrides = self: super: {

      aws-sam-translator = super.aws-sam-translator.overridePythonAttrs (oldAttrs: rec {
        version = "1.14.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1cghn1m7ana9s8kyg61dwp9mrism5l04vy5rj1wnmksz8vzmnq9w";
        };
      });

      jsonschema = super.jsonschema.overridePythonAttrs (oldAttrs: rec {
        version = "3.1.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0grwi50v3vahvcijlw6g6q55yc5jyj0p1cmiq3rkycxnfr16i81g";
        };
        nativeBuildInputs = [ super.setuptools_scm ];
        propagatedBuildInputs = with super; oldAttrs.propagatedBuildInputs ++ [ pyrsistent attrs importlib-metadata ];
        doCheck = false;
      });

    };
  };

in

with py.pkgs;

buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "0.22.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1flbvqlj5llz7nrszmcf00v2a1pa36alv90r1l8lwn8zid5aabkn";
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

  # fix over-restrictive version bounds
  postPatch = ''
    substituteInPlace requirements/base.txt --replace "requests==2.20.1" "requests==2.22.0"
    substituteInPlace requirements/base.txt --replace "serverlessrepo==0.1.9" "serverlessrepo~=0.1.9"
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
