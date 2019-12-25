{ lib
, python
}:

let
  py = python.override {
    packageOverrides = self: super: {
      flask = super.flask.overridePythonAttrs (oldAttrs: rec {
        version = "1.0.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0j6f4a9rpfh25k1gp7azqhnni4mb4fgy50jammgjgddw1l3w0w92";
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
  version = "0.34.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1ndgcbd6zr23lvmqn4wikgvnlwl0gj0wgyawaspwm3b0jlvxadik";
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
    tomlkit
  ];

  # fix over-restrictive version bounds
  postPatch = ''
    substituteInPlace requirements/base.txt \
      --replace "requests==2.20.1" "requests==2.22.0" \
      --replace "serverlessrepo==0.1.9" "serverlessrepo~=0.1.9" \
      --replace "six~=1.11.0" "six~=1.12.0" \
      --replace "python-dateutil~=2.6, <2.8.1" "python-dateutil~=2.6" \
      --replace "PyYAML~=3.12" "PyYAML~=5.1"
  '';

  meta = with lib; {
    homepage = https://github.com/awslabs/aws-sam-cli;
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ andreabedini dhkl ];
  };
}
