/*
  This file implements everything around meta.problems, including:
  - automaticProblems: Which problems get added automatically based on some condition
  - configOptions: Module system options for config.problems
  - problemsType: The check for meta.problems
  - genHandlerSwitch: The logic to determine the handler for a specific problem based on config.problems
  - genCheckProblems: The logic to determine which problems need to be handled and how the messages should look like

  There are tests to cover pretty much this entire file, so please run them when making changes ;)

      nix-build -A tests.problems
*/

{ lib }:

rec {

  inherit (lib.strings)
    escapeNixIdentifier
    ;

  inherit (lib)
    any
    listToAttrs
    concatStringsSep
    optionalString
    getName
    optionalAttrs
    pipe
    isString
    filterAttrs
    mapAttrs
    partition
    elemAt
    max
    foldl'
    elem
    filter
    concatMapStringsSep
    optional
    optionals
    concatLists
    all
    attrNames
    attrValues
    length
    mapAttrsToList
    groupBy
    subtractLists
    genAttrs
    concatMap
    unique
    ;

  handlers = rec {
    # Ordered from less to more
    levels = [
      "ignore"
      "warn"
      "error"
    ];

    lessThan =
      a: b:
      if a == "error" then
        false
      else if a == "warn" then
        b == "error"
      else
        b != "ignore";

    max = a: b: if lessThan a b then b else a;
  };

  kinds = {
    maintainerless = {
      manualAllowed = false;
      isUnique = false;
      nixpkgsInternalUseAllowed = true;
      automatic = {
        condition =
          # To get usable output, we want to avoid flagging "internal" derivations.
          # Because we do not have a way to reliably decide between internal or
          # external derivation, some heuristics are required to decide.
          #
          # If `outputHash` is defined, the derivation is a FOD, such as the output of a fetcher.
          # If `description` is not defined, the derivation is probably not a package.
          # Simply checking whether `meta` is defined is insufficient,
          # as some fetchers and trivial builders do define meta.
          config: attrs:
          # Order of checks optimised for short-circuiting the common case of having maintainers
          (attrs.meta.maintainers or [ ] == [ ])
          && (attrs.meta.teams or [ ] == [ ])
          && (!attrs ? outputHash)
          && (attrs ? meta.description);
        value.message = "This package has no declared maintainer, i.e. an empty `meta.maintainers` and `meta.teams` attribute.";
      };
    };
    broken = {
      manualAllowed = true;
      isUnique = false;
      nixpkgsInternalUseAllowed = true;
      automatic = {
        condition =
          config:
          let
            # TODO: Consider deprecating this or making it generic for all problems
            allowBroken = config.allowBroken || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1";

            allowBrokenPredicate =
              lib.warnIf (lib.oldestSupportedReleaseIsAtLeast 2605)
                "config.allowBrokenPredicate is deprecated, use config.problems.handlers.myPackage.broken = \"warn\" for individual packages instead."
                config.allowBrokenPredicate;
          in
          if allowBroken then
            attrs: false
          else if config ? allowBrokenPredicate then
            attrs: attrs ? meta.broken && attrs.meta.broken && !allowBrokenPredicate attrs
          else
            attrs: attrs ? meta.broken && attrs.meta.broken;
        value.message = "This package is broken.";
      };
    };
    removal = {
      manualAllowed = true;
      isUnique = true;
      nixpkgsInternalUseAllowed = false;
      automatic = null;
    };
    deprecated = {
      manualAllowed = true;
      isUnique = false;
      nixpkgsInternalUseAllowed = false;
      automatic = null;
    };
  };

  # Problem kinds that are currently allowed to be specified in `meta.problems`
  manualKinds = lib.filterAttrs (name: value: value.manualAllowed) kinds;
  # Problem kinds that are currently only allowed to be specified once
  uniqueKinds = lib.filterAttrs (name: value: value.isUnique) kinds;

  disallowNixpkgsInternalUseKinds = lib.filterAttrs (
    name: value: !value.nixpkgsInternalUseAllowed
  ) kinds;

  automaticProblems = lib.mapAttrsToList (name: value: value.automatic // { kindName = name; }) (
    lib.filterAttrs (name: value: value.automatic != null) kinds
  );

  genAutomaticProblems =
    config: attrs:
    listToAttrs (
      map (problem: lib.nameValuePair problem.kindName problem.value) (
        filter (problem: problem.condition config attrs) automaticProblems
      )
    );

  # A module system type for Nixpkgs config
  configOptions =
    let
      types = lib.types;
      handlerType = types.enum handlers.levels;
      problemKindType = types.enum (attrNames kinds);
    in
    {
      handlers = lib.mkOption {
        type = with types; attrsOf (attrsOf handlerType);
        default = { };
        description = ''
          Specify how to handle packages with problems.
          Each key has the format `packageName.problemName`, each value is one of "error", "warn" or "ignore".

          This option takes precedence over anything in `problems.matchers`.

          Package names are taken from `lib.getName`, which looks at the `pname` first and falls back to extracting the "pname" part from the `name` attribute.

          See [Installing packages with problems](https://nixos.org/manual/nixpkgs/stable/#sec-ignore-problems) in the NixOS manual.
        '';
      };

      matchers = lib.mkOption {
        type = types.listOf (
          types.submodule (
            { config, ... }:
            {
              options = {
                package = lib.mkOption {
                  type = types.nullOr types.str;
                  description = "Match problems of packages with this name";
                  default = null;
                };
                name = lib.mkOption {
                  type = types.nullOr types.str;
                  description = "Match problems with this problem name";
                  default = null;
                };
                kind = lib.mkOption {
                  type = types.nullOr problemKindType;
                  description = "Match problems of this problem kind";
                  default = null;
                };
                handler = lib.mkOption {
                  type = handlerType;
                  description = "Specify the handler for matched problems";
                };

                # Temporary hack to get assertions in submodules, see global assertions below
                assertions = lib.mkOption {
                  type = types.listOf types.anything;
                  default = [ ];
                  internal = true;
                };
              };
              config = {
                assertions =
                  # Using optional because otherwise message would be evaluated even when assertion is true
                  (
                    optional (config.package != null && config.name != null) {
                      assertion = false;
                      # TODO: Does it really matter if we let people specify this? Maybe not, so consider removing this assertion
                      message = ''
                        There is a problems.matchers with `package = "${config.package}"` and `name = "${config.name}". Use the following instead:
                          problems.handlers.${escapeNixIdentifier config.package}.${escapeNixIdentifier config.name} = "${config.handler}";
                      '';
                    }
                  );
              };
            }
          )
        );
        default = [ ];
        description = ''
          A more powerful and less ergonomic version of `problems.handlers`.
          Each value is a matcher, that may match onto certain properties of a problem and specify a handler for them.

          If multiple matchers match a problem, the handler with the highest severity (error > warn > ignore) will be used.
          Values in `problems.handlers` always take precedence over matchers.

          Any matchers must not contain both a `package` and `name` field, for this should be handled by using `problems.handlers` instead.
        '';
        example = [
          {
            kind = "maintainerless";
            handler = "warn";
          }
          {
            package = "myPackageICareAbout";
            handler = "error";
          }
        ];
      };
    };

  # The type for meta.problems
  problemsType =
    let
      types = import ../../../lib/meta-types.nix { inherit lib; };
      inherit (types)
        str
        listOf
        attrsOf
        record
        enum
        ;
      # While we should only allow manual kinds, we need to allow `meta.problems = otherPackage.meta.problems`, which includes automatic ones as well
      kindType = enum (attrNames kinds);
      subRecord = record {
        kind = kindType;
        message = str;
        urls = listOf str;
      };
      simpleType = attrsOf subRecord;
    in
    {
      name = "problems";
      verify =
        v:
        v == { }
        ||
          simpleType.verify v
          && all (problem: problem ? message) (attrValues v)
          && (
            let
              kindGroups = groupBy (kind: kind) (mapAttrsToList (name: problem: problem.kind or name) v);
            in
            all (kind: kinds ? ${kind} && (uniqueKinds ? ${kind} -> length kindGroups.${kind} == 1)) (
              attrNames kindGroups
            )
          );
      errors =
        ctx: v:
        let
          kindGroups = groupBy (attrs: attrs.kind) (
            mapAttrsToList (name: problem: {
              inherit name;
              explicit = problem ? kind;
              kind = problem.kind or name;
            }) v
          );
        in
        if !simpleType.verify v then
          types.errors simpleType ctx v
        else
          concatLists (
            mapAttrsToList (name: p: optional (!p ? message) "${ctx}.${name}: `.message` not specified") v
          )
          ++ concatLists (
            mapAttrsToList (
              kind: kindGroup:
              optionals (!kinds ? ${kind}) (
                map (
                  el:
                  "${ctx}.${el.name}: Problem kind ${kind}, inferred from the problem name, is invalid; expected ${kindType.name}. You can specify an explicit problem kind with `${ctx}.${el.name}.kind`"
                ) (filter (el: !el.explicit) kindGroup)
              )
              ++
                optional (uniqueKinds ? ${kind} && length kindGroup > 1)
                  "${ctx}: Problem kind ${kind} should be unique, but is used for these problems: ${
                    concatMapStringsSep ", " (el: el.name) kindGroup
                  }"
            ) kindGroups
          );
    };

  /*
    Construct a structure as follows, with the invariant that a more specific path always has a stricter handler, forming a lattice.
    E.g. if `packageSpecific.foo.nameFallback.kindFallback == "warn"`, then `packageFallback.nameFallback.kindFallback` must be "ignore".

      packageSpecific.<package> = {
        nameSpecific.<name> = {
          kindSpecific.<kind> = <ignore|warn|error>;
          kindFallback = <ignore|warn|error>;
        };
        nameFallback = {
          kindSpecific.<kind> = <ignore|warn|error>;
          kindFallback = <ignore|warn|error>;
        };
      };
      packageFallback = {
        nameSpecific.<name> = {
          kindSpecific.<kind> = <ignore|warn|error>;
          kindFallback = <ignore|warn|error>;
        };
        nameFallback = {
          kindSpecific.<kind> = <ignore|warn|error>;
          kindFallback = <ignore|warn|error>;
        };
      };

      Returns:
      - the structure itself for inspection
      - a function that can query the structure with very few allocations/lookups
      - a list of problem kinds/names/packages that require handling

    This allows collapsing arbitrarily many problem handlers/matchers into a predictable structure that can be queried in a predictable and fast way
  */
  genHandlerSwitch =
    config:
    let
      constraints =
        # matchers have low priority
        map (m: m // { priority = 0; }) config.problems.matchers
        # handlers have higher priority
        ++ concatLists (
          mapAttrsToList (
            package: forPackage:
            mapAttrsToList (name: handler: {
              inherit package name handler;
              kind = null;
              priority = 1;
            }) forPackage
          ) config.problems.handlers
        );

      # Lookup table for all the kinds/names/packages that actually need to be
      # handled
      definedConstraints = listToAttrs (
        map (ident: {
          name = "${ident}s"; # plural
          value = unique (
            concatMap (
              constraint:
              optionals (constraint.${ident} != null && constraint.handler != "ignore") [ (constraint.${ident}) ]
            ) constraints
          );
        }) identOrder
      );

      getHandler =
        list:
        (foldl'
          (acc: el: {
            priority = max acc.priority el.priority;
            handler =
              if acc.priority == el.priority then
                handlers.max acc.handler el.handler
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

      identOrder = [
        "kind"
        "name"
        "package"
      ];

      doLevel =
        index:
        let
          ident = elemAt identOrder index;
          nextLevel = if index + 1 == length identOrder then getHandler else doLevel (index + 1);
        in
        list:
        let
          # Partition all matchers into ident-specific (.wrong) and -unspecific (.right) ones
          parted = partition (m: isNull m.${ident}) list;
          # We only use the unspecific ones to compute the fallback
          fallback = nextLevel parted.right;
          specific = pipe parted.wrong [
            (groupBy (m: m.${ident}))
            # For ident-specific handlers, the unspecific ones also apply
            (mapAttrs (package: handlers: nextLevel (handlers ++ parted.right)))
            # Memory optimisation: Don't need a specific handler if it would end up the same as the fallback
            (filterAttrs (name: res: res != fallback))
          ];
        in
        # Optimisation in case it's always the same handler,
        # can propagate up for the entire switch to just be a string
        if specific == { } && isString fallback then
          fallback
        else
          {
            "${ident}Fallback" = fallback;
            "${ident}Specific" = specific;
          };
      switch = doLevel 0 constraints;
    in
    {
      inherit switch definedConstraints;
      handlerForProblem =
        if isString switch then
          kind: name: pname:
          switch
        else
          kind:
          let
            kindSwitch = switch.kindSpecific.${kind} or switch.kindFallback;
          in
          if isString kindSwitch then
            name: pname: kindSwitch
          else
            name:
            let
              nameSwitch = kindSwitch.nameSpecific.${name} or kindSwitch.nameFallback;
            in
            if isString nameSwitch then
              pname: nameSwitch
            else
              pname: nameSwitch.packageSpecific.${pname} or nameSwitch.packageFallback;
    };

  genCheckProblems =
    config:
    let
      # This is here so that it gets cached for a (checkProblems config) thunk
      inherit (genHandlerSwitch config)
        handlerForProblem
        definedConstraints
        ;

      # All the problem kinds that actually need to be checked
      configuredProblems = definedConstraints.kinds ++ definedConstraints.names;

      # Filter out any problems that are always ignored in config.problems.
      # Makes sure to cache the condition by appliny config, and the handler
      # by applying the problem's kind and name
      automaticProblemsConfigCache = concatMap (
        problem:
        optional (elem problem.kindName configuredProblems) {
          condition = problem.condition config;
          handler = handlerForProblem problem.kindName problem.kindName;
        }
      ) automaticProblems;
    in
    attrs:
    if
      # Fast path for when there's no problem that needs to be handled
      all (
        problem: problem.condition attrs -> problem.handler (getName attrs) == "ignore"
      ) automaticProblemsConfigCache
      && (
        # No manual problems
        !attrs ? meta.problems
        # Or all manual problems are ignored
        || all (
          name: handlerForProblem (attrs.meta.problems.${name}.kind or name) name (getName attrs) == "ignore"
        ) (attrNames attrs.meta.problems)
      )
    then
      null
    else
      # Slow path, only here we actually figure out which problems we need to handle
      let
        pname = getName attrs;
        problems = attrs.meta.problems or { } // genAutomaticProblems config attrs;
        problemsToHandle = filter (v: v.handler != "ignore") (
          mapAttrsToList (name: problem: rec {
            inherit name;
            # Kind falls back to the name
            kind = problem.kind or name;
            handler = handlerForProblem kind name pname;
            inherit problem;
          }) problems
        );
      in
      processProblems pname problemsToHandle;

  completeMetaProblems =
    config: attrs:
    mapAttrs (name: problem: { kind = name; } // problem) (
      (attrs.meta.problems or { }) // genAutomaticProblems config attrs
    );

  processProblems =
    pname: problemsToHandle:
    let
      grouped = groupBy (v: v.handler) problemsToHandle;

      warnProblems = grouped.warn or [ ];
      errorProblems = grouped.error or [ ];

      # assert annotatedProblems != [ ];
      fullMessage =
        v:
        "${v.name}${optionalString (v.kind != v.name) " (kind \"${v.kind}\")"}: "
        + "${v.problem.message}${
          optionalString (v.problem.urls or [ ] != [ ]) " (${concatStringsSep ", " v.problem.urls})"
        }";

      warnings = map (x: {
        reason = "problem";
        inherit (x) kind;
        msg = "has the following problem: ${fullMessage x}";
        remediation = "See https://nixos.org/manual/nixpkgs/unstable#sec-problems"; # TODO: Add remediation, maybe just link to docs to keep it small
      }) warnProblems;

      error =
        if errorProblems == [ ] then
          null
        else
          {
            reason = "problem";
            # Only there for PR CI evaluation
            handleProblem =
              handleEvalIssue:
              lib.foldl' (result: problem: handleEvalIssue problem.kind (fullMessage problem)) true errorProblems;
            msg = ''
              has problems:
              ${concatMapStringsSep "\n" (x: "- ${fullMessage x}") errorProblems}
            '';
            ## TODO: Add mention of problem.matchers, or maybe better link to docs of that
            remediation = ''
              See also https://nixos.org/manual/nixpkgs/unstable#sec-problems
              To allow evaluation regardless, use:
              - Nixpkgs import: import nixpkgs { config = <below code>; }
              - NixOS: nixpkgs.config = <below code>;
              - nix-* commands: Put below code in ~/.config/nixpkgs/config.nix

                {
                  problems.handlers = {
                    ${concatMapStringsSep "\n      " (
                      problem:
                      ''${escapeNixIdentifier pname}.${escapeNixIdentifier problem.name} = "warn"; # or "ignore"''
                    ) errorProblems}
                  };
                }
            '';
          };
    in
    {
      inherit error warnings;
    };

}
