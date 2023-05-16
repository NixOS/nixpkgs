{ lib
, python3
<<<<<<< HEAD
, fetchPypi
, groff
, less
}:

python3.pkgs.buildPythonApplication rec {
  pname = "awscli";
  version = "1.29.9"; # N.B: if you change this, change botocore and boto3 to a matching version too

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-8SmOu79FZESL1Hd15wdd1m1Uewswqaum2y8LOZAl9P8=";
=======
, fetchFromGitHub
, groff
, less
}:
let
  py = python3.override {
    packageOverrides = self: super: {
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
    self = py;
  };

in
with py.pkgs; buildPythonApplication rec {
  pname = "awscli";
  version = "1.27.79"; # N.B: if you change this, change botocore and boto3 to a matching version too

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-A3MVM5MV+PTwR4W2ALrqEtMaFtVAEt8yqkd4ZLsvHGE=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # https://github.com/aws/aws-cli/issues/4837
  postPatch = ''
    substituteInPlace setup.py \
      --replace "docutils>=0.10,<0.17" "docutils>=0.10" \
      --replace "colorama>=0.2.5,<0.4.5" "colorama>=0.2.5,<0.5" \
      --replace "rsa>=3.1.2,<4.8" "rsa<5,>=3.1.2"
  '';

<<<<<<< HEAD
  propagatedBuildInputs = with python3.pkgs; [
    botocore
    bcdoc
    s3transfer
=======
  propagatedBuildInputs = [
    botocore
    bcdoc
    s3transfer
    six
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    python = python3; # for aws_shell
  };

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/aws --version | grep "${python3.pkgs.botocore.version}"
=======
    python = py; # for aws_shell
  };

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/aws --version | grep "${py.pkgs.botocore.version}"
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    $out/bin/aws --version | grep "${version}"

    runHook postInstallCheck
  '';

  meta = with lib; {
    homepage = "https://aws.amazon.com/cli/";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    mainProgram = "aws";
    maintainers = with maintainers; [ ];
  };
}
