{
  expected,
  actual,
  path,
}:

let
  pkgs = import path {
    system = "x86_64-linux";

    # Just evaluate as much as possible.
    config = {
      allowUnfree = true;
      allowInsecure = true;
      allowBroken = true;
    };
  };

  inherit (pkgs) lib;

  show = lib.generators.toPretty { multiline = false; };

  allAttrPaths = expected // actual;

  differences =
    lib.concatMapAttrs
      (attrPath: _v: lib.optionalAttrs (expected.${attrPath} or null != actual.${attrPath} or null) {
        ${attrPath} = {
          expected = expected.${attrPath} or "NOT RECURSED INTO";
          actual = actual.${attrPath} or "NOT RECURSED INTO";
        };
      })
      allAttrPaths;

  report = lib.concatStringsSep "\n"
    (lib.mapAttrsToList
      (attrPath: { expected, actual }: ''
        ${"    "}${attrPath}:
                expected: ${show expected}
                actual:   ${show actual}''
      )
      differences
    );

  commands =
    lib.concatStringsSep
      "\n"
      (lib.mapAttrsToList
        (attrPath: { expected, actual }:
          if lib.strings.hasPrefix "/" expected && lib.strings.hasPrefix "/" actual
          then
          # We instantiate the derivations again. Storing them would be
          # inefficient, because most of the time we don't need them, and many
          # would be duplicated because of the sharding.
          ''
            expected=$($nix_expected/bin/nix-instantiate \
              $path \
              --attr '${attrPath}' \
              --argstr system x86_64-linux \
              --arg config '{ allowUnfree = true; allowInsecure = true; allowBroken = true; }')
            actual=$($nix_actual/bin/nix-instantiate \
              $path \
              --attr '${attrPath}' \
              --argstr system x86_64-linux \
              --arg config '{ allowUnfree = true; allowInsecure = true; allowBroken = true; }')
            nix-diff --color=always $actual $expected | tee $out/diffs/'${attrPath}.diff.color'
            nix-diff $actual $expected > $out/diffs/'${attrPath}.diff'
            touch $out/failed
          ''
          else ''
            cat | tee $out/diffs/'${attrPath}' <<EOF
            ${attrPath}:
                expected: ${show expected}
                actual: ${show actual}
            EOF
            touch $out/failed
          ''
        )
        differences
      );


in
{
  inherit commands;
  report = if report == "" then "OK" else report;
}

