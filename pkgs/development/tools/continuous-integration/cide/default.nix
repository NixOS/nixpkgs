{ wrapCommand, lib, bundlerEnv, makeWrapper, docker, git, gnutar, gzip }:

let
  env = bundlerEnv {
    name = "cide-gems";
    gemdir = ./.;
  };
in wrapCommand "cide" {
  inherit (env.gems.cide) version;
  executable = "${env}/bin/cide";
  makeWrapperArgs = ["--set PATH ${lib.makeBinPath [ docker git gnutar gzip ]}"];
  meta = with lib; {
    description = "Isolated test runner with Docker";
    homepage    = http://zimbatm.github.io/cide/;
    license     = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms   = docker.meta.platforms;
  };
}
