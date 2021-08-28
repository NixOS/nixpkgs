{ lib
, nixosTests
, python3
, groff
, less
}:
let
  py = python3.override {
    packageOverrides = self: super: {
      # TODO: https://github.com/aws/aws-cli/pull/5712
      colorama = super.colorama.overridePythonAttrs (oldAttrs: rec {
        version = "0.4.3";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "189n8hpijy14jfan4ha9f5n06mnl33cxz7ay92wjqgkr639s0vg9";
        };
      });
    };
  };

in
with py.pkgs; buildPythonApplication rec {
  pname = "awscli";
  version = "1.19.52"; # N.B: if you change this, change botocore and boto3 to a matching version too

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-keKyuNeDC/90pn89KjoDTO8AGsmI8nqfDNSeGyM6iHQ=";
  };

  # https://github.com/aws/aws-cli/issues/4837
  postPatch = ''
    substituteInPlace setup.py \
      --replace "docutils>=0.10,<0.16" "docutils>=0.10"
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

  passthru = {
    python = py; # for aws_shell

    tests = { inherit (nixosTests) awscli; };
  };

  meta = with lib; {
    homepage = "https://aws.amazon.com/cli/";
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ muflax ];
  };
}
