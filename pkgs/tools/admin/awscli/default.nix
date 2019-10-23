{ lib
, python
, groff
, less
, fetchpatch
}:

let
  py = python.override {
    packageOverrides = self: super: {
      rsa = super.rsa.overridePythonAttrs (oldAttrs: rec {
        version = "3.4.2";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "25df4e10c263fb88b5ace923dd84bf9aa7f5019687b5e55382ffcdb8bede9db5";
        };
      });
      colorama = super.colorama.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.9";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "48eb22f4f8461b1df5734a074b57042430fb06e1d61bd1e11b078c0fe6d7a1f1";
        };
      });
      pyyaml = super.pyyaml_3;
    };
  };

in py.pkgs.buildPythonApplication rec {
  pname = "awscli";
  version = "1.16.215"; # N.B: if you change this, change botocore to a matching version too

  src = py.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "13r32z8iyza4gvpf81l6l2ywv37yxi4bb08ry7cli5m6ny9xqlq8";
  };

  # No tests included
  doCheck = false;

  pythonPath = with py.pkgs; [
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
    urllib3
    dateutil
    jmespath
    futures
  ];

  postInstall = ''
    mkdir -p $out/etc/bash_completion.d
    echo "complete -C $out/bin/aws_completer aws" > $out/etc/bash_completion.d/awscli
    mkdir -p $out/share/zsh/site-functions
    mv $out/bin/aws_zsh_completer.sh $out/share/zsh/site-functions
    rm $out/bin/aws.cmd
  '';

  meta = with lib; {
    homepage = https://aws.amazon.com/cli/;
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ muflax ];
  };
}
