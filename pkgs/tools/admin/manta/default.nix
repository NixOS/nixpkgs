{ lib
, buildNpmPackage
, fetchFromGitHub
, installShellFiles
, testers
, node-manta
}:

buildNpmPackage rec {
  pname = "manta";
  version = "5.4.2";

  src = fetchFromGitHub {
    owner = "TritonDataCenter";
    repo = "node-manta";
    rev = "v${version}";
    hash = "sha256-Uj3fNzeERiO++sW2uyAbtfN/1Ed6uRVBBvCecncq/QY=";
  };

  npmDepsHash = "sha256-Xk/K90K+X73ZTV6u2GJij8815GdBn6igXmpWLaCfKF4=";

  dontBuild = true;

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    ln -s ./lib/node_modules/manta/bin $out/bin
  '';

  postFixup = ''
    # create completions, following upstream procedure https://github.com/joyent/node-manta/blob/v5.4.1/Makefile#L85-L91
    cmds=$(find ./bin/ -type f -printf "%f\n")

    node $out/lib/node_modules/manta/lib/create_client.js

    for cmd in $cmds; do
      installShellCompletion --cmd $cmd --bash <($out/bin/$cmd --completion)

      # Strip timestamp from generated bash completion
      sed -i '/Bash completion generated.*/d' $out/share/bash-completion/completions/$cmd.bash
    done
  '';

  passthru = {
    tests.version = testers.testVersion {
      package = node-manta;
    };
  };

  meta = with lib; {
    description = "Manta Object-Storage Client CLIs and Node.js SDK";
    homepage = "https://github.com/TritonDataCenter/node-manta";
    changelog = "https://github.com/TritonDataCenter/node-manta/blob/v${version}/CHANGES.md";
    license = licenses.mit;
    maintainers = with maintainers; [ teutat3s ];
    mainProgram = "mls";
  };
}
