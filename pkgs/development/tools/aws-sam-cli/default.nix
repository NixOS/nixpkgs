{ fetchFromGitHub
, lib
, python
, enableTelemetry ? false
}:

let
  py = python.override {
    packageOverrides = self: super: {
      flask = super.flask.overridePythonAttrs (oldAttrs: rec {
        version = "1.1.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0q3h295izcil7lswkzfnyg3k5gq4hpmqmpl6i7s5m1n9szi1myjf";
        };
      });

      cookiecutter = super.cookiecutter.overridePythonAttrs (oldAttrs: rec {
        version = "1.7.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1b2xa5dypk1vf8aq599fd8zw4y0pwvq3hgl7ia8aiv8gg3ab5dpg";
        };
      });
    };
  };

in

with py.pkgs;

buildPythonApplication rec {
  pname = "aws-sam-cli";
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1drb8qcn30r44m0jy0y1nvhzxphn3qari5qwmsdb6wlkdppwxg3f";
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
    jmespath
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
      --replace "boto3~=1.14.23" "boto3~=1.14" \
      --replace "docker~=4.2.0" "docker~=4.3.1" \
      --replace "jmespath~=0.9.5" "jmespath~=0.10.0" \
      --replace "python-dateutil~=2.6, <2.8.1" "python-dateutil~=2.6" \
      --replace "requests==2.23.0" "requests~=2.24" \
      --replace "serverlessrepo==0.1.9" "serverlessrepo~=0.1.9" \
      --replace "tomlkit==0.5.8" "tomlkit~=0.7.0"
  '';

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-sam-cli";
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ andreabedini lo1tuma ];
  };
}
