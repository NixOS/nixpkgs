{ lib
, buildNpmPackage
, fetchurl
, nodejs
, installShellFiles
, testers
, node-manta
}:

let
  source = lib.importJSON ./source.json;
in
buildNpmPackage rec {
  pname = "manta";
  inherit (source) version;

  src = fetchurl {
    url = "https://registry.npmjs.org/${pname}/-/${source.filename}";
    hash = source.integrity;
  };

  npmDepsHash = source.deps;

  dontBuild = true;

  nativeBuildInputs = [ nodejs installShellFiles ];

  postPatch = ''
    # Use generated package-lock.json as upstream does not provide one
    ln -s ${./package-lock.json} package-lock.json
  '';

  postInstall = ''
    ln -s ./lib/node_modules/manta/bin $out/bin
  '';

  postFixup = ''
    # create completions, following upstream procedure https://github.com/joyent/node-manta/blob/v5.3.2/Makefile#L85-L91
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
    updateScript = ./update.sh;
  };

  meta = with lib; {
    description = "Manta Object-Storage Client CLIs and Node.js SDK";
    homepage = "https://github.com/TritonDataCenter/node-manta";
    license = licenses.mit;
    maintainers = with maintainers; [ teutat3s ];
    mainProgram = "mls";
  };
}
