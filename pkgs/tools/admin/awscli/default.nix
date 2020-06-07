{ lib
, python3
, groff
, less
}:

let
  py = python3.override {
    packageOverrides = self: super: {
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
  version = "1.18.74"; # N.B: if you change this, change botocore to a matching version too

  src = fetchPypi {
    inherit pname version;
    sha256 = "1681945m9wxzqx4yv09zxskkbs2fd8rz1r3krjpwrpar3iiq1nmj";
  };

  postPatch = ''
    substituteInPlace setup.py --replace ",<0.16" ""
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
    mkdir -p $out/etc/bash_completion.d
    echo "complete -C $out/bin/aws_completer aws" > $out/etc/bash_completion.d/awscli
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
