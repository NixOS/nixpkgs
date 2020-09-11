{ lib
, python3
, groff
, less
, fetchFromGitHub
}:
let
  py = python3.override {
    packageOverrides = self: super: {
      botocore = super.botocore.overridePythonAttrs (oldAttrs: rec {
        version = "2.0.0dev50";
        src = fetchFromGitHub {
          owner = "boto";
          repo = "botocore";
          rev = "e3dceaf9052cc8e221ea757207d5ba37054af2b8";
          sha256 = "0fcf78il4z6gr4gg0jy2h5045ifkslsgldnk6zyvzcl5gykp8i2f";
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
  version = "2.0.46"; # N.B: if you change this, change botocore to a matching version too

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = version;
    hash = "sha256:10bq4m7hsmj1m7nwr3jgpfvm8bx091vl2hig574r1bjmsi32vy58";
  };

  postPatch = ''
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
    mkdir -p $out/etc/bash_completion.d
    echo "complete -C $out/bin/aws_completer aws" > $out/etc/bash_completion.d/awscli
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
