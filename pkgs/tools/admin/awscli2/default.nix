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
        version = "2.0.0dev30";
        src = fetchFromGitHub {
          owner = "boto";
          repo = "botocore";
          rev = "7967b9c5fb027c9962e0876f0110425da88b88f2";
          sha256 = "18yn5l1f4nr1pih392qkyidnj7z10bd2cv7yx4qrl7asxxraspr9";
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
  version = "2.0.26"; # N.B: if you change this, change botocore to a matching version too

  src = fetchFromGitHub {
    owner = "aws";
    repo = "aws-cli";
    rev = version;
    hash = "sha256:1ysmr17gbcj6vs9ywzwgvd9caxwxgg9bnfvvkyks4fii34ji5qq8";
  };

  postPatch = ''
    substituteInPlace setup.py --replace ",<0.16" ""
    substituteInPlace setup.py --replace "wcwidth<0.2.0" "wcwidth"
    substituteInPlace setup.py --replace "cryptography>=2.8.0,<=2.9.0" "cryptography>=2.8.0,<2.10"
  '';

  # No tests included
  doCheck = false;

  propagatedBuildInputs = [
    bcdoc
    botocore
    colorama
    cryptography
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
