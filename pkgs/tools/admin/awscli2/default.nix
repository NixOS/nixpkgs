{ lib
, python3
, groff
, less
, fetchFromGitHub
, nix-update-script
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      awscrt = super.awscrt.overridePythonAttrs (oldAttrs: rec {
        version = "0.14.0";
        src = self.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          hash = "sha256-MGLTFcsWVC/gTdgjny6LwyOO6QRc1QcLkVzy677Lqqw=";
        };
      });

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
  version = "2.8.9"; # N.B: if you change this, check if overrides are still up-to-date
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = version;
    sha256 = "sha256-7So0zPknO5rIiWY7o82HXl+Iw2+fQmhYvrfrFMCDdDE=";
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
    wcwidth
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
    substituteInPlace pyproject.toml \
      --replace "colorama>=0.2.5,<0.4.4" "colorama" \
      --replace "distro>=1.5.0,<1.6.0" "distro" \
      --replace "docutils>=0.10,<0.16" "docutils" \
      --replace "wcwidth<0.2.0" "wcwidth"
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
      attrPath = pname;
    };
  };

  meta = with lib; {
    homepage = "https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple davegallant bryanasdev000 devusb anthonyroussel ];
  };
}
