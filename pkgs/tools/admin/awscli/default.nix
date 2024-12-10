{
  lib,
  python3,
  fetchPypi,
  groff,
  less,
  nix-update-script,
  testers,
  awscli,
}:

let
  botocoreVersion = python3.pkgs.botocore.version;
  # awscli.version should be pinned to 2 minor versions less than the botocoreVersion
  versionMinor = toString (lib.toInt (lib.versions.minor botocoreVersion) - 2);
  versionPatch = lib.versions.patch botocoreVersion;
  self = python3.pkgs.buildPythonApplication rec {
    pname = "awscli";
    version = "1.${versionMinor}.${versionPatch}"; # N.B: if you change this, change botocore and boto3 to a matching version too
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-GPcXkl2H0XNaeqt2/qD5+KvW23dRB0X+zLWo9hLigQM=";
    };

    nativeBuildInputs = [
      python3.pkgs.pythonRelaxDepsHook
    ];

    pythonRelaxDeps = [
      # botocore must not be relaxed
      "colorama"
      "docutils"
      "rsa"
    ];

    build-system = [
      python3.pkgs.setuptools
    ];

    propagatedBuildInputs = with python3.pkgs; [
      botocore
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

      $out/bin/aws --version | grep "${botocoreVersion}"
      $out/bin/aws --version | grep "${version}"

      runHook postInstallCheck
    '';

    passthru = {
      python = python3; # for aws_shell
      updateScript = nix-update-script {
        extraArgs = [ "--version=skip" ];
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
  };
in
assert self ? pythonRelaxDeps -> !(lib.elem "botocore" self.pythonRelaxDeps);
self
