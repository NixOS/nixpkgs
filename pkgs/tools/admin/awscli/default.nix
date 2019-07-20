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
      pyyaml = super.pyyaml.overridePythonAttrs (oldAttrs: rec {
        version = "3.13";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "3ef3092145e9b70e3ddd2c7ad59bdd0252a94dfe3949721633e41344de00a6bf";
        };
        # https://github.com/yaml/pyyaml/issues/298#issuecomment-511990948
        patches = lib.singleton (fetchpatch {
          url = "https://github.com/yaml/pyyaml/commit/c5b135fe39d41cffbdc006f28ccb2032df6005e0.patch";
          sha256 = "0x1v45rkmj194c41d1nqi3ihj9z4rsy8zvpfcd8p960g1fia7fhn";
        });
      });
    };
  };

in py.pkgs.buildPythonApplication rec {
  pname = "awscli";
  version = "1.16.170"; # N.B: if you change this, change botocore to a matching version too

  src = py.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "12kh62imdfy8whvqzdrmdq4zw70gj1g3smqldf4lqpjfzss7cy92";
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
