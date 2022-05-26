{ lib
, python3
, fetchFromGitHub
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
      docutils = super.docutils.overridePythonAttrs (oldAttrs: rec {
        version = "0.16";
        src = oldAttrs.src.override {
          inherit version;
          sha256 = "sha256-wt46YOnn0Hvia38rAMoDCcIH4GwQD5zCqUkx/HWkePw=";
        };
      });
      pyyaml = super.pyyaml.overridePythonAttrs (oldAttrs: rec {
        version = "5.4.1";
        src = fetchFromGitHub {
          owner = "yaml";
          repo = "pyyaml";
          rev = version;
          hash = "sha256-VUqnlOF/8zSOqh6JoEYOsfQ0P4g+eYqxyFTywgCS7gM=";
        };
        checkPhase = ''
          runHook preCheck
          PYTHONPATH="tests/lib3:$PYTHONPATH" ${self.python.interpreter} -m test_all
          runHook postCheck
        '';
      });
    };
  };

in
with py.pkgs; buildPythonApplication rec {
  pname = "awscli";
  version = "1.24.9"; # N.B: if you change this, change botocore and boto3 to a matching version too

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8tdymQX3j7pLkqE8FcABpBgHwhqXKj37diVe3n+fAsU=";
  };

  # https://github.com/aws/aws-cli/issues/4837
  postPatch = ''
    substituteInPlace setup.py \
      --replace "docutils>=0.10,<0.16" "docutils>=0.10" \
      --replace "rsa>=3.1.2,<4.8" "rsa<5,>=3.1.2"
  '';

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
  };

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/aws --version | grep "${py.pkgs.botocore.version}"
    $out/bin/aws --version | grep "${version}"

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://aws.amazon.com/cli/";
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    maintainers = with maintainers; [ muflax bryanasdev000 ];
  };
}
