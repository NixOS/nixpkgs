{
  # Plumbing tools:
  closureInfo
, runCommand
, writeText
, buildEnv
, # Actual dependencies to propagate:
  bash
, coreutils
}:
let
  tools = buildEnv {
    name = "lorri-runtime-tools";
    paths = [ coreutils bash ];
  };

  runtimeClosureInfo = closureInfo {
    rootPaths = [ tools ];
  };

  closureToNix = runCommand "closure.nix" {}
    ''
      (
        echo '{ dep, ... }: ['
        sed -E 's/^(.*)$/    (dep \1)/' ${runtimeClosureInfo}/store-paths
        echo ']'
      ) > $out
    '';

  runtimeClosureInfoAsNix = runCommand "runtime-closure.nix" {
    runtime_closure_list = closureToNix;
    tools_build_host = tools;
  }
    ''
      substituteAll ${./runtime-closure.nix.template} $out
    '';
in
runtimeClosureInfoAsNix
