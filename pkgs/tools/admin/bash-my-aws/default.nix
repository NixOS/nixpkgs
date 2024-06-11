{ lib, stdenv
, makeWrapper
, awscli
, jq
, unixtools
, fetchFromGitHub
, installShellFiles
, bashInteractive
}:

stdenv.mkDerivation rec {
  pname = "bash-my-aws";
  version = "unstable-2020-01-11";

  src = fetchFromGitHub {
    owner = "bash-my-aws";
    repo = "bash-my-aws";
    rev = "5a97ce2c22affca1299022a5afa109d7b62242ba";
    sha256 = "sha256-RZvaiyRK8FnZbHyLkWz5VrAcsnMtHCiIo64GpNZgvqY=";
  };

  dontConfigure = true;
  dontBuild = true;

  propagatedBuildInputs = [
    awscli
    jq
    unixtools.column
    bashInteractive
  ];
  nativeBuildInputs = [ makeWrapper installShellFiles ];

  checkPhase = ''
    pushd test
    ./shared-spec.sh
    ./stack-spec.sh
    popd
  '';
  installPhase=''
    mkdir -p $out
    cp -r . $out
  '';
  postFixup = ''
    pushd $out
    substituteInPlace scripts/build \
        --replace '~/.bash-my-aws' $out
    substituteInPlace scripts/build-completions \
        --replace "{HOME}" $out \
        --replace '~/.bash-my-aws' $out
    ./scripts/build
    ./scripts/build-completions
    substituteInPlace bash_completion.sh \
        --replace "{HOME}" $out \
        --replace .bash-my-aws ""
    substituteInPlace bin/bma \
        --replace '~/.bash-my-aws' $out
    wrapProgram $out/bin/bma --prefix PATH : ${lib.makeBinPath [awscli jq unixtools.column bashInteractive ]}
    installShellCompletion --bash --name bash-my-aws.bash bash_completion.sh
    chmod +x $out/lib/*
    patchShebangs --host $out/lib
    installShellCompletion --bash --name bash-my-aws.bash bash_completion.sh
    cat > $out/bin/bma-init <<EOF
    echo source $out/aliases
    echo source $out/bash_completion.sh
    EOF
    chmod +x $out/bin/bma-init
    popd
  '';

  meta = with lib; {
    homepage = "https://bash-my-aws.org";
    description = "CLI commands for AWS";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
