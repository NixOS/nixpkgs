{ lib
, python3
, fetchPypi
, groff
, less
, nix-update-script
, testers
, awscli
}:

python3.pkgs.buildPythonApplication rec {
  pname = "awscli";
  version = "1.30.2"; # N.B: if you change this, change botocore and boto3 to a matching version too

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-XbYsPbYUIJPCS+nhcE3A5K7yxHcGUkulT5vHPT5T9kM=";
  };


  propagatedBuildInputs = with python3.pkgs; [
    botocore
    bcdoc
    s3transfer
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

  doInstallCheck = true;

  installCheckPhase = ''
    runHook preInstallCheck

    $out/bin/aws --version | grep "${python3.pkgs.botocore.version}"
    $out/bin/aws --version | grep "${version}"

    runHook postInstallCheck
  '';

  passthru = {
    python = python3; # for aws_shell
    updateScript = nix-update-script {
      # Excludes 1.x versions from the Github tags list
      extraArgs = [ "--version-regex" "^(1\.(.*))" ];
    };
    tests.version = testers.testVersion {
      package = awscli;
      command = "aws --version";
      inherit version;
    };
  };

  meta = with lib; {
    homepage = "https://aws.amazon.com/cli/";
    changelog = "https://github.com/aws/aws-cli/blob/${version}/CHANGELOG.rst";
    description = "Unified tool to manage your AWS services";
    license = licenses.asl20;
    mainProgram = "aws";
    maintainers = with maintainers; [ anthonyroussel ];
  };
}
