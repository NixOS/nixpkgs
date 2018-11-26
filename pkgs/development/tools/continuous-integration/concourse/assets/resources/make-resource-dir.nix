{ runCommand, linkFarm }:
let
  inherit (builtins) map attrNames;
  mkResourcesDir =
  resources:
  linkFarm
    "concourse-resources"
    (map
      (res: {
        name = res;
        path = resources."${res}".dir;
      })
      (attrNames resources)
    );
in
mkResourcesDir
