{ wrapCommand, lib, bundlerEnv, makeWrapper, groff }:

let
  env = bundlerEnv rec {
    name = "ronn-gems";
    gemdir = ./.;
  };
in wrapCommand "ronn" {
  version = env.gems.ronn.version;
  executable = "${env}/bin/ronn";
  makeWrapperArgs = ["--set PATH ${groff}/bin"];
  meta = with lib; {
    description = "markdown-based tool for building manpages";
    homepage = https://rtomayko.github.io/ronn/;
    license = licenses.mit;
    maintainers = with maintainers; [ zimbatm ];
    platforms = env.ruby.meta.platforms;
  };
}
