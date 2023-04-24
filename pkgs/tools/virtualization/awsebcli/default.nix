{ lib, python3, glibcLocales, docker-compose_1 }:
let
  docker_compose = changeVersion (with localPython.pkgs; docker-compose_1.override {
    inherit colorama pyyaml six dockerpty docker jsonschema requests websocket-client paramiko;
  }).overridePythonAttrs "1.25.5" "sha256-ei622Bc/30COUF5vfUl6wLd3OIcZVCvp5JoO/Ud6UMY=";

  changeVersion = overrideFunc: version: hash: overrideFunc (oldAttrs: rec {
    inherit version;
    src = oldAttrs.src.override {
      inherit version hash;
    };
  });

  localPython = python3.override
    {
      self = localPython;
      packageOverrides = self: super: {
        cement = changeVersion super.cement.overridePythonAttrs "2.8.2" "sha256-h2XtBSwGHXTk0Bia3cM9Jo3lRMohmyWdeXdB9yXkItI=";
        wcwidth = changeVersion super.wcwidth.overridePythonAttrs "0.1.9" "sha256-7nOGKGKhVr93/5KwkDT8SCXdOvnPgbxbNgZo1CXzxfE=";
        semantic-version = changeVersion super.semantic-version.overridePythonAttrs "2.8.5" "sha256-0sst4FWHYpNGebmhBOguynr0SMn0l00fPuzP9lHfilQ=";
        pyyaml = super.pyyaml.overridePythonAttrs (oldAttrs: rec {
          version = "5.4.1";
          checkPhase = ''
            runHook preCheck
            PYTHONPATH="tests/lib3:$PYTHONPATH" ${localPython.interpreter} -m test_all
            runHook postCheck
          '';
          src = localPython.pkgs.fetchPypi {
            pname = "PyYAML";
            inherit version;
            hash = "sha256-YHd0y7oocyv6gCtUuqdIQhX1MJkQVbtWLvvtWy8gpF4=";
          };
        });
      };
    };
in
with localPython.pkgs; buildPythonApplication rec {
  pname = "awsebcli";
  version = "3.20.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-9n6nObYoZlOKgQvSdNqHLRr+RlDoKfR3fgD7Xa9wPzM=";
  };


  preConfigure = ''
    substituteInPlace requirements.txt \
      --replace "six>=1.11.0,<1.15.0" "six==1.16.0" \
      --replace "requests>=2.20.1,<=2.26" "requests<3" \
      --replace "pathspec==0.10.1" "pathspec>=0.10.0,<1" \
      --replace "colorama>=0.2.5,<0.4.4" "colorama>=0.2.5,<=0.4.6" \
      --replace "termcolor == 1.1.0" "termcolor>=2.0.0,<3"
  '';

  buildInputs = [
    glibcLocales
  ];

  nativeCheckInputs = [
    pytest
    mock
    nose
    pathspec
    colorama
    requests
    docutils
  ];

  doCheck = true;

  propagatedBuildInputs = [
    blessed
    botocore
    cement
    colorama
    pathspec
    pyyaml
    future
    requests
    semantic-version
    setuptools
    tabulate
    termcolor
    websocket-client
    docker_compose
  ];

  meta = with lib; {
    homepage = "https://aws.amazon.com/elasticbeanstalk/";
    description = "A command line interface for Elastic Beanstalk";
    changelog = "https://github.com/aws/aws-elastic-beanstalk-cli/blob/${version}/CHANGES.rst";
    maintainers = with maintainers; [ eqyiel kirillrdy ];
    license = licenses.asl20;
  };
}
