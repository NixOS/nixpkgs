{ lib
, python
, enableTelemetry ? false
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

      cookiecutter = super.cookiecutter.overridePythonAttrs (oldAttrs: rec {
        version = "1.6.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0glsvaz8igi2wy1hsnhm9fkn6560vdvdixzvkq6dn20z3hpaa5hk";
        };
      });
    };
  };

in

with py.pkgs;

buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "0.41.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v21bhylys1mvrsvxqw88cvghl6s46hdni52xn661bbn4byrrv3b";
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

  postFixup = if enableTelemetry then "echo aws-sam-cli TELEMETRY IS ENABLED" else ''
    # Disable telemetry: https://github.com/awslabs/aws-sam-cli/issues/1272
    wrapProgram $out/bin/sam --set  SAM_CLI_TELEMETRY 0
  '';

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
    maintainers = with maintainers; [ andreabedini lo1tuma ];
  };
}
