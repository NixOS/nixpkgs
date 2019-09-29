{ lib
, python3
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      jsonschema = super.jsonschema.overridePythonAttrs (oldAttrs: rec {
        version = "3.0.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "03anb4ljl624lixrsaxfi7i1iwavw39sd8cfkhcy0dr2dixjnjld";
        };
        nativeBuildInputs = with super; [ setuptools_scm ];
        propagatedBuildInputs = with super; [ attrs setuptools importlib-metadata pyrsistent six ];
        checkInputs = with super; [ twisted pytest ];
        checkPhase = ''pytest --ignore=jsonschema/tests/test_validators.py'';
      });

      aws-sam-translator = super.aws-sam-translator.overridePythonAttrs (oldAttrs: rec {
        version = "1.14.0";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1cghn1m7ana9s8kyg61dwp9mrism5l04vy5rj1wnmksz8vzmnq9w";
        };
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
    jsonschema
    requests
    serverlessrepo
    six
  ] ++ lib.optionals python3.isPy27 [ enum34 pathlib2 ];

  postPatch = ''
    substituteInPlace requirements/base.txt --replace "requests==2.22.0" "requests~=2.22"
    substituteInPlace requirements/base.txt --replace "six~=1.11.0" "six~=1.11"
    substituteInPlace requirements/base.txt --replace "PyYAML~=3.12" "PyYAML"
  '';

  meta = with lib; {
    homepage = https://github.com/awslabs/aws-sam-cli;
    description = "CLI tool for local development and testing of Serverless applications";
    license = licenses.asl20;
    maintainers = with maintainers; [ andreabedini dhkl ];

    longDescription = ''
      The AWS Serverless Application Model (SAM) is an open-source framework
      for building serverless applications. It provides shorthand syntax
      to express functions, APIs, databases, and event source mappings.
      With just a few lines of configuration, you can define the application
      you want and model it.
    '';
  };
}
