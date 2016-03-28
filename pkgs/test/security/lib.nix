let
  lib = import ../../../lib;
in

with lib;

rec {
  inherit lib;

  originalPackages = {
    adapters = import ../../../pkgs/stdenv/adapters.nix;
    builders = import ../../../pkgs/build-support/trivial-builders.nix;
    stdenv = import ../../../pkgs/top-level/stdenv.nix;
    all = import ../../../pkgs/top-level/all-packages.nix;
    aliases = import ../../../pkgs/top-level/aliases.nix;
  };

  pkgs = import ../../../. {
    defaultPackages = originalPackages;
    quickfixPackages = null;
    doPatchWithDependencies = false;
  } // { recurseForDerivations = true; };

  onefix = import ../../../. {
    defaultPackages = originalPackages;
    quickfixPackages = originalPackages;
    doPatchWithDependencies = false;
  } // { recurseForDerivations = true; };

  abifix = import ../../../. {
    defaultPackages = originalPackages;
    quickfixPackages = originalPackages;
    doPatchWithDependencies = true;
  } // { recurseForDerivations = true; };

  # This is the same as the `collectWithPath` function of Nixpkgs's library,
  # except that it uses `tryEval` to ignore invalid evaluations, such as
  # broken and unfree packages.
  #
  # Example:
  #   maybeCollectWithPath (x: x ? outPath)
  #      { a = { outPath = "a/"; }; b = { outPath = "b/"; }; }
  #   => [ { path = ["a"]; value = { outPath = "a/"; }; }
  #        { path = ["b"]; value = { outPath = "b/"; }; }
  #      ]
  #
  maybeCollectWithPath = pred: attrs: with lib;
    let
      collectInternal = path: attrs:
        # assert __trace (["maybeCollectWithPath::"] ++ path) true;
        addErrorContext "while collecting derivations under ${concatStringsSep "." path}:" (
        if pred attrs then
          [ { path = concatStringsSep "." path; value = attrs; } ]
        else if isAttrs attrs && attrs.recurseForDerivations or false then
          concatMap (name: maybeCollectInternal (path ++ [name]) attrs.${name})
            (attrNames attrs)
        else
          []);

       maybeCollectInternal = path: attrs:
         # Some evaluation of isAttrs might raise an assertion while
         # evaluating Nixpkgs, tryEval is used to work-around this issue.
         let res = builtins.tryEval (collectInternal path attrs); in
         if res.success then res.value
         else [];

    in
      maybeCollectInternal [] attrs;

  # Collect all derivations.
  collectDerivations = with lib; pkgs:
    maybeCollectWithPath (drv: isDerivation drv && drv.outPath != "") pkgs;

  pkgsDrvs = collectDerivations pkgs;
  onefixDrvs = collectDerivations onefix;
  abifixDrvs = collectDerivations abifix;

  # Zip all packages collected so far, and verify that they are equal.
  zipPkgs =
    lib.zipListsWith
      (p: o: p.path == o.path && p.value.outPath == o.value.outPath);
}
