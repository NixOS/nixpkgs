{ lib, python3, glibcLocales, docker-compose }:
let
  docker_compose = changeVersion (with localPython.pkgs; docker-compose.override {
    inherit colorama pyyaml six dockerpty docker jsonschema requests websocket-client paramiko;
  }).overridePythonAttrs "1.25.5" "1ijhg93zs3lswkljnm0rhww7gdy0g94psvsya2741prz2zcbcbks";

  changeVersion = overrideFunc: version: sha256: overrideFunc (oldAttrs: rec {
    inherit version;
    src = oldAttrs.src.override {
      inherit version sha256;
    };
  });

  changeVersionHash = overrideFunc: version: hash: overrideFunc (oldAttrs: rec {
    inherit version;
    src = oldAttrs.src.override {
      inherit version hash;
    };
  });

  localPython = python3.override
    {
      self = localPython;
      packageOverrides = self: super: {
        cement = changeVersion super.cement.overridePythonAttrs "2.8.2" "1li2whjzfhbpg6fjb6r1r92fb3967p1xv6hqs3j787865h2ysrc7";
        botocore = changeVersion super.botocore.overridePythonAttrs "1.23.54" "sha256-S7m6FszO5fWiYCBJvD4ttoZTRrJVBmfzATvfM7CgHOs=";
        colorama = changeVersion super.colorama.overridePythonAttrs "0.4.3" "189n8hpijy14jfan4ha9f5n06mnl33cxz7ay92wjqgkr639s0vg9";
        future = changeVersion super.future.overridePythonAttrs "0.16.0" "1nzy1k4m9966sikp0qka7lirh8sqrsyainyf8rk97db7nwdfv773";
        requests = changeVersionHash super.requests.overridePythonAttrs "2.26.0" "sha256-uKpY+M95P/2HgtPYyxnmbvNverpDU+7IWedGeLAbB6c=";
        six = changeVersion super.six.overridePythonAttrs "1.14.0" "02lw67hprv57hyg3cfy02y3ixjk3nzwc0dx3c4ynlvkfwkfdnsr3";
        wcwidth = changeVersion super.wcwidth.overridePythonAttrs "0.1.9" "1wf5ycjx8s066rdvr0fgz4xds9a8zhs91c4jzxvvymm1c8l8cwzf";
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

  buildInputs = [
    glibcLocales
  ];

  LC_ALL = "en_US.UTF-8";

  checkInputs = [
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
