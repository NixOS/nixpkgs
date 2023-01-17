{ lib
, python3
, groff
, less
, fetchFromGitHub
, nix-update-script
, testers
, awscli2
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      prompt-toolkit = super.prompt-toolkit.overridePythonAttrs (oldAttrs: rec {
        version = "3.0.28";
        src = self.fetchPypi {
          pname = "prompt_toolkit";
          inherit version;
          hash = "sha256-nxzRax6GwpaPJRnX+zHdnWaZFvUVYSwmnRTp7VK1FlA=";
        };
      });
    };
  };

in
with py.pkgs; buildPythonApplication rec {
  pname = "awscli2";
  version = "2.9.15"; # N.B: if you change this, check if overrides are still up-to-date
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = version;
    hash = "sha256-yOqxz6ZsBV7iNKjG3NlV8SUHaezlchiUx8RRShRU6xo=";
  };

  nativeBuildInputs = [
    flit-core
  ];

  propagatedBuildInputs = [
    awscrt
    bcdoc
    colorama
    cryptography
    distro
    docutils
    groff
    less
    prompt-toolkit
    pyyaml
    rsa
    ruamel-yaml
    python-dateutil
    jmespath
    urllib3
  ];

  checkInputs = [
    jsonschema
    mock
    pytestCheckHook
  ];

  postPatch = ''
    sed -i pyproject.toml \
      -e 's/colorama.*/colorama",/' \
      -e 's/cryptography.*/cryptography",/' \
      -e 's/distro.*/distro",/'
  '';

  postInstall = ''
    mkdir -p $out/${python3.sitePackages}/awscli/data
    ${python3.interpreter} scripts/gen-ac-index --index-location $out/${python3.sitePackages}/awscli/data/ac.index

    mkdir -p $out/share/bash-completion/completions
    echo "complete -C $out/bin/aws_completer aws" > $out/share/bash-completion/completions/aws

    mkdir -p $out/share/zsh/site-functions
    mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions

    rm $out/bin/aws.cmd
  '';

  doCheck = true;

  preCheck = ''
    export PATH=$PATH:$out/bin
    export HOME=$(mktemp -d)
  '';

  pytestFlagsArray = [
    "-Wignore::DeprecationWarning"
  ];

  disabledTestPaths = [
    # Integration tests require networking
    "tests/integration"

    # Disable slow tests (only run unit tests)
    "tests/backends"
    "tests/functional"
  ];

  pythonImportsCheck = [
    "awscli"
  ];

  passthru = {
    python = py; # for aws_shell
    updateScript = nix-update-script {
      # Excludes 1.x versions from the Github tags list
      extraArgs = [ "--version-regex" "^(2\.(.*))" ];
    };
    tests.version = testers.testVersion {
      package = awscli2;
      command = "aws --version";
      version = version;
    };
  };

  meta = with lib; {
    homepage = "https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple davegallant bryanasdev000 devusb anthonyroussel ];
    mainProgram = "aws";
  };
}
