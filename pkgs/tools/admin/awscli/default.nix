{ lib
, python3
, groff
, less
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      botocore = super.botocore.overridePythonAttrs (oldAttrs: rec {
        pname = "botocore";
        version = "1.19.23";
        src = super.fetchPypi {
          inherit pname version;
          sha256 = "07j851gc3zxz7q9894hh201jcgabgqvzmsnf6g0xkcia9fjgr7lz";
        };
      });
      rsa = super.rsa.overridePythonAttrs (oldAttrs: rec {
        version = "3.4.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5";
        };
      });
    };
  };

in with py.pkgs; buildPythonApplication rec {
  pname = "awscli";
  version = "1.18.183"; # N.B: if you change this, change botocore to a matching version too

  src = fetchPypi {
    inherit pname version;
    sha256 = "0n1pmdl33r1v8qnrcg08ihvri9zm4fvsp14605vwmlkxvs8nb7s5";
  };

  postPatch = ''
    substituteInPlace setup.py --replace "docutils>=0.10,<0.16" "docutils>=0.10"
    substituteInPlace setup.py --replace "colorama>=0.2.5,<0.4.4" "colorama>=0.2.5"
  '';

  # No tests included
  doCheck = false;

  propagatedBuildInputs = [
    botocore
    bcdoc
    s3transfer
    six
    colorama
    docutils
    rsa
    pyyaml
    groff
    less
  ];

  postInstall = ''
    mkdir -p $out/share/bash-completion/completions
    echo "complete -C $out/bin/aws_completer aws" > $out/share/bash-completion/completions/awscli

    mkdir -p $out/share/zsh/site-functions
    mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions

    rm $out/bin/aws.cmd
  '';

  passthru.python = py; # for aws_shell

  meta = with lib; {
    homepage = "https://aws.amazon.com/cli/";
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ muflax ];
  };
}
