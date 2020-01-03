{ lib
, python3
, groff
, less
}:

let
  py = python3.override {
    packageOverrides = self: super: {
      colorama = super.colorama.overridePythonAttrs (oldAttrs: rec {
        version = "0.4.1";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "05eed71e2e327246ad6b38c540c4a3117230b19679b875190486ddd2d721422d";
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

in py.pkgs.buildPythonApplication rec {
  pname = "awscli";
  version = "1.16.266"; # N.B: if you change this, change botocore to a matching version too

  src = py.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "9c59a5ca805f467669d471b29550ecafafb9b380a4a6926a9f8866f71cd4f7be";
  };

  # No tests included
  doCheck = false;

  propagatedBuildInputs = with py.pkgs; [
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
    homepage = https://aws.amazon.com/cli/;
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ muflax ];
  };
}
