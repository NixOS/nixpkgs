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
  py = python3 // {
    pkgs = python3.pkgs.overrideScope (self: super: {
      # nothing right now
    });
  };

in
with py.pkgs; buildPythonApplication rec {
  pname = "awscli2";
  version = "2.12.3"; # N.B: if you change this, check if overrides are still up-to-date
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = version;
    hash = "sha256-56eRINxIAuVkgySNvk+bOEC1sYgkOeujNQsIihKefc8=";
  };

  postPatch = ''
    substituteInPlace requirements/bootstrap.txt \
      --replace "pip>=22.0.0,<23.0.0" "pip>=22.0.0,<24.0.0"
  '';

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

  nativeCheckInputs = [
    jsonschema
    mock
    pytestCheckHook
  ];

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
