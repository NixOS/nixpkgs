{ lib, python3, glibcLocales, docker-compose_1 }:
let
  docker_compose = changeVersion (with localPython.pkgs; docker-compose_1.override {
    inherit colorama pyyaml six dockerpty docker jsonschema requests websocket-client paramiko;
  }).overridePythonAttrs "1.25.5" "1ijhg93zs3lswkljnm0rhww7gdy0g94psvsya2741prz2zcbcbks";

  changeVersion = overrideFunc: version: sha256: overrideFunc (oldAttrs: rec {
    inherit version;
    src = oldAttrs.src.override {
      inherit version sha256;
    };
  });

  localPython = python3.override
    {
      self = localPython;
      packageOverrides = self: super: {
        cement = changeVersion super.cement.overridePythonAttrs "2.8.2" "1li2whjzfhbpg6fjb6r1r92fb3967p1xv6hqs3j787865h2ysrc7";
        future = changeVersion super.future.overridePythonAttrs "0.16.0" "1nzy1k4m9966sikp0qka7lirh8sqrsyainyf8rk97db7nwdfv773";
        wcwidth = changeVersion super.wcwidth.overridePythonAttrs "0.1.9" "1wf5ycjx8s066rdvr0fgz4xds9a8zhs91c4jzxvvymm1c8l8cwzf";
        semantic-version = changeVersion super.semantic-version.overridePythonAttrs "2.8.5" "d2cb2de0558762934679b9a104e82eca7af448c9f4974d1f3eeccff651df8a54";
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
            sha256 = "sha256-YHd0y7oocyv6gCtUuqdIQhX1MJkQVbtWLvvtWy8gpF4=";
          };
        });
      };
    };
in
with localPython.pkgs; buildPythonApplication rec {
  pname = "awsebcli";
  version = "3.20.3";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-W3nUXPAXoicDQNXigktR1+b/9W6qvi90fujrXAekxTU=";
  };


  preConfigure = ''
    substituteInPlace setup.py \
      --replace "six>=1.11.0,<1.15.0" "six==1.16.0" \
      --replace "requests>=2.20.1,<=2.26" "requests==2.28.1" \
      --replace "botocore>1.23.41,<1.24.0" "botocore>1.23.41,<2" \
      --replace "pathspec==0.9.0" "pathspec>=0.10.0,<0.11.0" \
      --replace "colorama>=0.2.5,<0.4.4" "colorama>=0.2.5,<=0.4.6" \
      --replace "termcolor == 1.1.0" "termcolor>=2.0.0,<2.2.0"
  '';

  buildInputs = [
    glibcLocales
  ];

  LC_ALL = "en_US.UTF-8";

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
    maintainers = with maintainers; [ eqyiel ];
    license = licenses.asl20;
  };
}
