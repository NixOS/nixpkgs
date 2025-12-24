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
  maxProblemHandler = a: b: if problemLessThan a b then b else a;

  problemLessThan =
    a: b:
    if a == "error" then
      false
    else if a == "warn" then
      b == "error"
    else
      b != "ignore";

  # Currently known list of known problem kinds. Keep up to date with pkgs/top-level/config.nix
  problemKinds = [
    "removal"
    "deprecated"
    "maintainerless"
    "insecure"
    "broken"
    "unsupported"
  ];

  reservedProblemNames = lib.subtractLists problemKindsManual problemKinds;

  # Problem kinds that are currently allowed in `meta.problems`
  problemKindsManual = [
    "removal"
    "deprecated"
  ];
  problemKindsManual' = lib.genAttrs problemKindsManual (k: null);

  # Problem kinds that are only allowed up to once per package
  problemKindsUnique = [
    "removal"
    "maintainerless"
  ];
  # Same thing but a set with null values (comes in handy at times)
  problemKindsUnique' = lib.genAttrs problemKindsUnique (k: null);

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

  /*
      Construct a structure as follows, with the invariant that a more specific path always has a stricter handler. E.g. if byPackage.foo.fallback.fallback == "warn", then fallback.fallback.fallback must be "ignore".

      The unspecific/specific handlers for a specific problem form a lattice.

      specific.<package> = {
        specific.<name> = {
          specific.<kind> = <ignore|warn|error>;
          fallback = <ignore|warn|error>;
        };
        fallback = {
          specific.<kind> = <ignore|warn|error>;
          fallback = <ignore|warn|error>;
        };
      };
      fallback = {
        specific.<name> = {
          specific.<kind> = <ignore|warn|error>;
          fallback = <ignore|warn|error>;
        };
        fallback = {
          specific.<kind> = <ignore|warn|error>;
          fallback = <ignore|warn|error>;
        };
      };

      We can query this structure with:

        switch:
        let
          forPackage = switch.specific.${package} or switch.fallback;
          forName = forPackage.specific.${name} or forPackage.fallback;
          handler = forName.specific.${kind} or forName.fallback;
        in
        handler

      which should be fairly quick
    }
  */
  genHandlerSwitch =
    {
      handlers,
      matchers,
      identOrder,
    }:
    assert lib.length identOrder == 3;
    assert lib.all (ident: lib.elem ident identOrder) [
      "kind"
      "name"
      "package"
    ];
    let
      constraints' =
        # matchers have low priority
        lib.map (m: m // { priority = 0; }) matchers
        # handlers have higher priority
        ++ lib.concatLists (
          lib.mapAttrsToList (
            package: forPackage:
            lib.mapAttrsToList (name: handler: {
              inherit package name handler;
              kind = null;
              priority = 1;
            }) forPackage
          ) handlers
        );

      constraints = lib.filter (
        matcher:
        (
          lib.elem matcher.name reservedProblemNames -> (isNull matcher.kind || matcher.kind == matcher.name)
        )
        && (
          lib.elem matcher.kind reservedProblemNames -> (isNull matcher.name || matcher.kind == matcher.name)
        )
      ) constraints';

      getHandler =
        list:
        (lib.foldl'
          (acc: el: {
            priority = lib.max acc.priority el.priority;
            handler =
              if acc.priority == el.priority then
                maxProblemHandler acc.handler el.handler
              else if acc.priority > el.priority then
                acc.handler
              else
                el.handler;
          })
          {
            priority = 0;
            handler = "ignore";
          }
          list
        ).handler;

      doLevel =
        index:
        let
          ident = lib.elemAt identOrder index;
          nextLevel = if index + 1 == lib.length identOrder then getHandler else doLevel (index + 1);
        in
        list:
        let
          # Partition all matchers into ident-specific (.wrong) and -unspecific (.right) ones
          parted = lib.partition (m: isNull m.${ident}) list;
          # We only use the unspecific ones to compute the fallback
          fallback = nextLevel parted.right;
          # TODO: If the name or kind is reserved, then we can be sure that it has the same name as kind, so any paths where those don't match can be discarded
          specific = lib.pipe parted.wrong [
            (lib.groupBy (m: m.${ident}))
            # For ident-specific handlers, the unspecific ones also apply
            (lib.mapAttrs (package: handlers: nextLevel (handlers ++ parted.right)))
            # Optimisation: Don't need a specific handler if it would end up the same as the fallback
            (lib.filterAttrs (name: res: res != fallback))
          ];
        in
        if specific == { } && lib.isString fallback then
          fallback
        else
          {
            "${ident}Fallback" = fallback;
            "${ident}Specific" = specific;
          };
      switch = doLevel 0 constraints;
      # Get each kind, if any is only fallbacks to ignore, then set `null`

      switch' = lib.genAttrs problemKinds (kind: switch.kindSpecific.${kind} or switch.kindFallback);

    in
    switch';
}
