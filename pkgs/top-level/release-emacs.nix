/*
  This file will be evaluated by hydra with a call like this:
  hydra_eval_jobs --gc-roots-dir \
    /nix/var/nix/gcroots/per-user/hydra/hydra-roots --argstr \
    system i686-linux --argstr system x86_64-linux --arg \
    nixpkgs "{outPath = ./}" .... release.nix

  Hydra can be installed with "nix-env -i hydra".
*/
{ supportedSystems ? [ "x86_64-linux" "i686-linux" "x86_64-darwin" "x86_64-freebsd" "i686-freebsd" ]
, nixpkgs ? { outPath = (import ./all-packages.nix {}).lib.cleanSource ../..; revCount = 1234; shortRev = "abcdef"; }}:

with (import ./release-lib.nix { inherit supportedSystems;});
let
  jobsForDerivations = attrset: pkgs.lib.attrsets.listToAttrs
    (map
      (name: { inherit name;
               value = { type = "job"; systems = ["x86_64-linux"]; schedulingPriority = 4; };})
      (builtins.attrNames
        (pkgs.lib.attrsets.filterAttrs
          (n: v: (v.type or null) == "derivation")
          attrset)));

in
(mapTestOn rec {
  emacs24Packages = jobsForDerivations pkgs.emacs24Packages;
})
