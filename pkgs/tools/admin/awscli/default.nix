{ lib
, python
, groff
, less
}:

let
  py = python.override {
    packageOverrides = self: super: {
      colorama = super.colorama.overridePythonAttrs (oldAttrs: rec {
        version = "0.3.7";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "0avqkn6362v7k2kg3afb35g4sfdvixjgy890clip4q174p9whhz0";
        };
      });
    };
  };

in py.pkgs.buildPythonApplication rec {
  pname = "awscli";
  version = "1.16.4";

  src = py.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "036cad15f7a551f3d1281b305deb04c6cf05aa3c23fa6d2bba7a0dc4eb5256de";
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

#   postPatch = ''
#     for i in {py,cfg}; do
#       substituteInPlace setup.$i --replace "botocore==1.10.10" "botocore>=1.10.9,<=1.11"
#     done
#   '';

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
