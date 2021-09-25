{ lib, python3, groff, less, fetchFromGitHub, fetchpatch }:
let
  py = python3.override {
    packageOverrides = self: super: {
      awscrt = super.awscrt.overridePythonAttrs (oldAttrs: rec {
        version = "0.11.24";
        src = self.fetchPypi {
          inherit (oldAttrs) pname;
          inherit version;
          sha256 = "sha256-uKpovKQEvwCFvgVw7/W1QtAffo48D5sIWav+XgcBYv8=";
        };
      });
      botocore = super.botocore.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.0dev147";
        src = fetchFromGitHub {
          owner = "boto";
          repo = "botocore";
          rev = "afa015418df6b3aeef0f5645e8704de64adea3d7";
          sha256 = "sha256-ypqDhCQXPqG8JCsLWt1V/4s95Hm+lClz+eOA2GnIhYg=";
        };
        propagatedBuildInputs = super.botocore.propagatedBuildInputs ++ [py.pkgs.awscrt];
      });
      prompt-toolkit = super.prompt-toolkit.overridePythonAttrs (oldAttrs: rec {
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
  version = "2.2.39"; # N.B: if you change this, change botocore to a matching version too

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = version;
    sha256 = "sha256-3GYj6+08J05Lu17jjydmzlypI5TUuV+5HA398oExkiU=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/mgorny/aws-cli/commit/85361123d2fa12eaedf912c046ffe39aebdd2bad.patch";
      sha256 = "sha256-1Rb+/CY7ze1/DbJ6TfqHF01cfI2vixZ1dT91bmHTg/A=";
    })
  ];

  postPatch = ''
    substituteInPlace setup.py \
      --replace "colorama>=0.2.5,<0.4.4" "colorama" \
      --replace "cryptography>=3.3.2,<3.4.0" "cryptography" \
      --replace "docutils>=0.10,<0.16" "docutils" \
      --replace "ruamel.yaml>=0.15.0,<0.16.0" "ruamel.yaml" \
      --replace "s3transfer>=0.4.2,<0.5.0" "s3transfer" \
      --replace "wcwidth<0.2.0" "wcwidth" \
      --replace "distro>=1.5.0,<1.6.0" "distro"
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
    prompt-toolkit
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
