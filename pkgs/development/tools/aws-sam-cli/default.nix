{ fetchFromGitHub
, lib
, python
, enableTelemetry ? false
}:

let
  py = python.override {
    packageOverrides = self: super: {
      aws-sam-translator = super.aws-sam-translator.overridePythonAttrs (oldAttrs: rec {
        version = "1.25.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "08756yl5lpqgrpr80f2b6bdcgygr37l6q1yygklcg9hz4yfpccav";
        };
      });

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
  version = "1.0.0rc1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "011b334gdvd9lhqia8c952q3cmzj99vik680180nbp0qh2xw6zpf";
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
      --replace "boto3~=1.13.0, >=1.13.0" "boto3~=1.14.3" \
      --replace "serverlessrepo==0.1.9" "serverlessrepo~=0.1.9" \
      --replace "python-dateutil~=2.6, <2.8.1" "python-dateutil~=2.6" \
      --replace "jmespath~=0.9.5" "jmespath~=0.10.0" \
      --replace "tomlkit==0.5.8" "tomlkit~=0.6.0" \
      --replace "requests==2.22.0" "requests~=2.22"
  '';

  meta = with lib; {
    homepage = "https://github.com/awslabs/aws-sam-cli";
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ andreabedini lo1tuma ];
  };
}
