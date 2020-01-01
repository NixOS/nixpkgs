{ stdenv
, awscli
, jq
, fetchgit
, installShellFiles
, bashInteractive
}:

stdenv.mkDerivation rec {
  pname = "bash-my-aws";
  version = "20191231";

  src = fetchgit {
    url = "https://github.com/bash-my-aws/bash-my-aws";
    rev = "ef93bd1bf8692dc2fe9f475e7c8a309eb25ef7a6";
    sha256 = "c57e8327a3dfa24f0c40b8c94eab55fa232f87044e7d59f7bc4b40e5012e83ed";
  };

  dontConfigure = true;
  dontBuild = true;

  # Why does it propagate packages that are used for testing?
  propagatedBuildInputs = [
    awscli
    jq
    bashInteractive
  ];
  nativeBuildInputs = [ installShellFiles ];

  #Checks are failing due to missing TTY, which won't exist.
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
    # substituteInPlace scripts/build \
    #     --replace '~/.bash-my-aws' $out
    # substituteInPlace scripts/build-completions \
    #     --replace "{HOME}" $out \
    #     --replace '~/.bash-my-aws' $out
    # ./scripts/build
    # ./scripts/build-completions
    # substituteInPlace bash_completion.sh \
    #     --replace "{HOME}" $out \
    #     --replace .bash-my-aws ""
    # substituteInPlace bin/bma \
    #     --replace '~/.bash-my-aws' $out
    # installShellCompletion --bash --name bash-my-aws.bash bash_completion.sh
    # chmod +x $out/lib/*
    # patchShebangs --host $out/lib
    # cat > $out/bin/bma-init <<EOF
    # echo source $out/aliases
    # echo source $out/bash
    # EOF
    # chmod +x $out/bin/bma-init
    popd
  '';

  meta = with stdenv.lib; {
    homepage = https://bash-my-aws.org;
    description = "CLI commands for AWS";
    license = licenses.mit;
    maintainers = with maintainers; [ tomberek ];
  };
}
