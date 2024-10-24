# Implementation of RFC 127

{ lib }:

rec {
  # Problem handler levels
  problemHandlers = [
    "error"
    "warn"
    "ignore"
  ];

  # Take the maximum (highest severity) problem handler
  maxProblemHandler =
    a: b:
    if a == "error" || b == "error" then
      "error"
    else if a == "warn" || b == "warn" then
      "warn"
    else
      "ignore";

  # Currently known list of known problem kinds. Keep up to date with pkgs/top-level/config.nix
  problemKinds = [
    "removal"
    "deprecated"
    "maintainerless"
    "insecure"
    "broken"
    "unsupported"
  ];

  # Problem kinds that are currently allowed in `meta.problems`
  problemKindsManual = [
    "removal"
    "deprecated"
  ];

  # Problem kinds that are only allowed up to once per package
  problemKindsUnique = [
    "removal"
    "maintainerless"
  ];
  # Same thing but a set with null values (comes in handy at times)
  problemKindsUnique' = lib.pipe problemKindsUnique [
    (map (name: {
      inherit name;
      value = null;
    }))
    lib.listToAttrs
  ];

  # Extract a list of problems from the derivation. Every problem has at least a `kind` and `message` field.
  # generateProblems :: Derivation -> [{ name, kind, message, handler, … }]
  generateProblems =
    # Pass through helper functions from check-meta
    { hasNoMaintainers }:
    # config.problems
    { handlers, matchers }:
    pkg:
    let
      # Sometimes the name field of a derivation has some string context attached to it.
      # This can happen for example if the name was generated from its src attribute, which is a derviation.
      # In that case getName would fail with something like "the string 'run-test-trivial-overriding-bin-fail' is not allowed to refer to a store path (such as '!out!/nix/store/k9c8q6c11wsi0f8skafn3hj69rjynn7l-test-trivial-overriding-bin-fail.drv')"
      # Using this is safe here because we only use the name for string comparisons, with no risk of it landing in a derivation.
      pkgName = lib.getName (pkg // { name = builtins.unsafeDiscardStringContext pkg.name; });

      # Take the problems plus add automatically generated ones
      problems =
        (pkg.meta.problems or { })
        // lib.optionalAttrs (hasNoMaintainers pkg) {
          maintainerless = {
            message = "This package has no declared maintainer, i.e. an empty `meta.maintainers` attribute";
          };
        };

      # Inject default values, since metaTypes can't do it for us currently
      addDefaults =
        name: problem:
        {
          inherit name;
          kind = name;
        }
        // problem;

      # Determine the handler level from config for this problem
      addHandler =
        problem:
        let
          handler =
            # Try to find an explicit handler
            (handlers.${pkgName} or { }).${problem.name}
              # Fall back, iterating through the matchers
              or (lib.pipe matchers [
                # Find matches
                (lib.filter (
                  matcher:
                  (if matcher.name != null then problem.name == matcher.name else true)
                  && (if matcher.kind != null then problem.kind == matcher.kind else true)
                  && (if matcher.package != null then pkgName == matcher.package else true)
                ))
                # Extract handler level
                (builtins.map (lib.getAttr "handler"))
                # Take the strongest matched handler level
                (lib.foldl' maxProblemHandler "ignore")
              ]);
        in
        problem // { inherit handler; };
    in
    builtins.map addHandler (lib.mapAttrsToList addDefaults problems);
}
