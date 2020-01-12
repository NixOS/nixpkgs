{ stdenv
, awscli
, jq
, fetchgit
, installShellFiles
, bashInteractive
}:

stdenv.mkDerivation rec {
  pname = "bash-my-aws";
  version = "20200111";

  src = fetchgit {
    url = "https://github.com/bash-my-aws/bash-my-aws";
    rev = "5a97ce2c22affca1299022a5afa109d7b62242ba";
    sha256 = "459bda8b244af059d96c7c8b916cf956b01cb2732d1c2888a3ae06a4d660bea6";
  };

  dontConfigure = true;
  dontBuild = true;

  propagatedBuildInputs = [
    awscli
    jq
    bashInteractive
  ];
  nativeBuildInputs = [ installShellFiles ];

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

  meta = with stdenv.lib; {
    homepage = https://bash-my-aws.org;
    description = "CLI commands for AWS";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
