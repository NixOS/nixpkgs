{ lib, python3, groff, less, fetchFromGitHub }:
let
  py = python3.override {
    packageOverrides = self: super: {
      botocore = super.botocore.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.0dev122";
        src = fetchFromGitHub {
          owner = "boto";
          repo = "botocore";
          rev = "8dd916418c8193f56226b7772f263b2435eae27a";
          sha256 = "sha256-iAZmqnffqrmFuxlQyOpEQzSCcL/hRAjuXKulOXoy4hY=";
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
  version = "2.2.14"; # N.B: if you change this, change botocore to a matching version too

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = version;
    sha256 = "sha256-LU9Tqzdi8ULZ5y3FbfSXdrip4NcxFkXRCTpVGo05LcM=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace "awscrt==0.11.13" "awscrt" \
      --replace "colorama>=0.2.5,<0.4.4" "colorama" \
      --replace "cryptography>=3.3.2,<3.4.0" "cryptography" \
      --replace "docutils>=0.10,<0.16" "docutils" \
      --replace "ruamel.yaml>=0.15.0,<0.16.0" "ruamel.yaml" \
      --replace "wcwidth<0.2.0" "wcwidth"
  '';

  checkInputs = [ jsonschema mock nose ];

  propagatedBuildInputs = [
    awscrt
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

  checkPhase = ''
    export PATH=$PATH:$out/bin

    # https://github.com/NixOS/nixpkgs/issues/16144#issuecomment-225422439
    export HOME=$TMP

    AWS_TEST_COMMAND=$out/bin/aws python scripts/ci/run-tests
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

  passthru.python = py; # for aws_shell

  meta = with lib; {
    homepage = "https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2.html";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ bhipple davegallant ];
  };
}
