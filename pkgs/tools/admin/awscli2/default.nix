{ lib, python3, groff, less, fetchFromGitHub }:
let
  py = python3.override {
    packageOverrides = self: super: {
      botocore = super.botocore.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.0dev97";
        src = fetchFromGitHub {
          owner = "boto";
          repo = "botocore";
          rev = "f240d284994b521b0bd099161bc0ab5786caf700";
          sha256 = "sha256-Ot3w/4OcQ+pXq6bJnQqV5uvG50/uIOa1pwMWqor5NXM=";
        };
      });
      prompt_toolkit = super.prompt_toolkit.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.10";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "1nr990i4b04rnlw1ghd0xmgvvvhih698mb6lb6jylr76cs7zcnpi";
        };
      });
    };
  };

in
with py.pkgs; buildPythonApplication rec {
  pname = "awscli2";
  version = "2.1.29"; # N.B: if you change this, change botocore to a matching version too

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = version;
    sha256 = "sha256-6SVDJeyPJQX4XIH8RYRzJG2LFDHxIrW/b1a0JZ5kIFY=";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "colorama>=0.2.5,<0.4.4" "colorama>=0.2.5"
    substituteInPlace setup.py --replace "cryptography>=2.8.0,<=2.9.0" "cryptography>=2.8.0"
    substituteInPlace setup.py --replace "docutils>=0.10,<0.16" "docutils>=0.10"
    substituteInPlace setup.py --replace "ruamel.yaml>=0.15.0,<0.16.0" "ruamel.yaml>=0.15.0"
    substituteInPlace setup.py --replace "wcwidth<0.2.0" "wcwidth"
  '';

  # No tests included
  doCheck = false;

  propagatedBuildInputs = [
    bcdoc
    botocore
    colorama
    cryptography
    distro
    docutils
    groff
    less
    prompt_toolkit
    pyyaml
    rsa
    ruamel_yaml
    s3transfer
    six
    wcwidth
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

  passthru.python = py; # for aws_shell

  meta = with lib; {
    homepage = "https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple davegallant ];
  };
}
