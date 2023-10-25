let
  ents = builtins.readDir ./.;
in builtins.listToAttrs (builtins.filter (x: x != null) (map (name: let
  match = builtins.match "(.*)\\.patch" name;
in if match == null then null else {
  name = builtins.head match;
  value = {
    name = "cpu-cgroup-v2-${name}";
    patch = ./. + "/${name}";
  };
}) (builtins.attrNames ents)))
