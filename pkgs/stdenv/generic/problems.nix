# Implementation of RFC 127

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
    ;

  handlers = rec {
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

  kinds = rec {
    known = [
      "removal"
      "deprecated"
      "maintainerless"
      "insecure"
      "broken"
      "unsupported"
    ];
    # Problem kinds that are currently allowed in `meta.problems`
    manual = [
      "removal"
      "deprecated"
    ];
    # Problem kinds that are only allowed up to once per package
    unique = [
      "removal"
      "maintainerless"
    ];
    # known \ manual
    reserved = subtractLists manual known;

    # Same thing but a set with null values (comes in handy at times)
    manual' = genAttrs manual (k: null);
    unique' = genAttrs unique (k: null);
  };

  automaticProblems = [
    {
      kindName = "maintainerless";
      condition =
        # To get usable output, we want to avoid flagging "internal" derivations.
        # Because we do not have a way to reliably decide between internal or
        # external derivation, some heuristics are required to decide.
        #
        # If `outputHash` is defined, the derivation is a FOD, such as the output of a fetcher.
        # If `description` is not defined, the derivation is probably not a package.
        # Simply checking whether `meta` is defined is insufficient,
        # as some fetchers and trivial builders do define meta.
        attrs:
        # Order of checks optimised for short-circuiting the common case of having maintainers
        (attrs.meta.maintainers or [ ] == [ ])
        && (attrs.meta.teams or [ ] == [ ])
        && (!attrs ? outputHash)
        && (attrs ? meta.description);
      value.message = "This package has no declared maintainer, i.e. an empty `meta.maintainers` and `meta.teams` attribute.";
    }
  ];

  genAutomaticProblems =
    attrs:
    listToAttrs (
      map (problem: lib.nameValuePair problem.kindName problem.value) (
        filter (problem: problem.condition attrs) automaticProblems
      )
    );

  # A module system type for Nixpkgs config
  configOptions =
    let
      types = lib.types;
      handlerType = types.enum handlers.levels;
      problemKindType = types.enum kinds.known;
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

          See <link xlink:href="https://nixos.org/manual/nixpkgs/stable/#sec-ignore-problems">Installing packages with problems</link> in the NixOS manual.
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
                assertions = [
                  {
                    assertion = !(config.package != null && config.name != null);
                    message = ''A matcher cannot match on both a package and problem name as this would not be a wildcard, for that use `problems.handlers = { ${toString config.package}.${toString config.name} = "${toString config.handler}"; };` instead'';
                  }
                ];
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
      types = import ./meta-types.nix { inherit lib; };
      inherit (types)
        str
        listOf
        record
        enum
        ;
      kindType = enum kinds.manual;
      subRecord = record {
        kind = kindType;
        message = str;
        urls = listOf str;
      };
    in
    {
      name = "problems";
      verify =
        v:
        if v == { } then
          true
        else
          let
            kinds'' = groupBy (p: p) (mapAttrsToList (name: p: p.kind or name) v);
          in
          subRecord.verify v
          && all (k: kinds.manual' ? ${k} && (kinds.unique' ? ${k} -> length kinds''.${k} == 1)) (
            attrNames kinds''
          );
      errors =
        ctx: v:
        let
          kinds'' = groupBy (p: p.kind) (
            mapAttrsToList (name: p: {
              inherit name;
              explicit = p ? kind;
              kind = p.kind or name;
            }) v
          );
        in
        concatLists (
          mapAttrsToList (
            name: p:
            optional (!p ? message) "${ctx}.${name}: `.message` not specified"
            ++ subRecord.errors "${ctx}.${name}" p
          ) v
        )
        ++ concatLists (
          mapAttrsToList (
            k: ks:
            optionals (!kinds.manual' ? ${k}) (
              map (
                k':
                "${ctx}.${k'.name}: Problem kind ${k}, inferred from the problem name, is invalid; expected ${kindType.name}. You can specify an explicit problem kind with `${ctx}.${k'.name}.kind`"
              ) (filter (k': !k'.explicit) ks)
            )
            ++
              optional (kinds.unique' ? ${k} && length ks > 1)
                "${ctx}: Problem kind ${k} should be unique, but is used for these problems: ${
                  concatMapStringsSep ", " (k': k'.name) ks
                }"
          ) kinds''
        );
    };

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
    config:
    let
      identOrder = [
        "kind"
        "name"
        "package"
      ];
      constraints' =
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

      constraints = filter (
        matcher:
        (elem matcher.name kinds.reserved -> (isNull matcher.kind || matcher.kind == matcher.name))
        && (elem matcher.kind kinds.reserved -> (isNull matcher.name || matcher.kind == matcher.name))
      ) constraints';

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
            # TODO: Set the default depending on the kind
            handler = "ignore";
          }
          list
        ).handler;

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
          # TODO: If the name or kind is reserved, then we can be sure that it has the same name as kind, so any paths where those don't match can be discarded
          specific = pipe parted.wrong [
            (groupBy (m: m.${ident}))
            # For ident-specific handlers, the unspecific ones also apply
            (mapAttrs (package: handlers: nextLevel (handlers ++ parted.right)))
            # Optimisation: Don't need a specific handler if it would end up the same as the fallback
            (filterAttrs (name: res: res != fallback))
          ];
        in
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
      inherit switch;
      # Mainly for manual problems
      handlerForProblem =
        pname: name: kind:
        let
          switch' = switch.kindSpecific.${kind} or switch.kindFallback or switch;
          switch'' = switch'.nameSpecific.${name} or switch'.nameFallback or switch';
        in
        switch''.packageSpecific.${pname} or switch''.packageFallback or switch'';
    };

  genCheckProblems =
    config:
    let
      # This is here so that it gets cached for a (checkProblems config) thunk
      inherit (genHandlerSwitch config)
        handlerForProblem
        ;
    in
    attrs:
    let
      pname = getName attrs;
      manualProblems = attrs.meta.problems or { };
    in
    if
      # Fast path for when there's no problem that needs to be handled
      # No automatic problems that needs handling
      all (
        problem:
        !problem.condition attrs || handlerForProblem pname problem.kindName problem.kindName == "ignore"
      ) automaticProblems
      && (
        # No manual problems
        manualProblems == { }
        # Or all manual problems are ignored
        || all (name: handlerForProblem pname name (manualProblems.${name}.kind or name) == "ignore") (
          attrNames manualProblems
        )
      )
    then
      null
    else
      # Slow path, only here we actually figure out which problems we need to handle
      let
        problems = attrs.meta.problems or { } // genAutomaticProblems attrs;
        problemsToHandle = filter (v: v.handler != "ignore") (
          mapAttrsToList (name: problem: rec {
            inherit name;
            # Kind falls back to the name
            kind = problem.kind or name;
            handler = handlerForProblem pname name kind;
            inherit problem;
          }) problems
        );
      in
      processProblems pname problemsToHandle;

  processProblems =
    pname: problemsToHandle:
    let
      grouped = groupBy (v: v.handler) problemsToHandle;

      warnProblems = grouped.warn or [ ];
      errorProblems = grouped.error or [ ];

      # assert annotatedProblems != [ ];
      fullMessage =
        v:
        "${v.name}${optionalString (v.kind != v.name) " (kind \"${v.kind}\""}: "
        + "${v.problem.message}${
          optionalString (v.problem.urls or [ ] != [ ]) " (${concatStringsSep ", " v.problem.urls})"
        }";

      warnings = map (x: {
        reason = "problem";
        errormsg = "has the following problem: ${fullMessage x}";
        remediation = ""; # TODO, maybe just link to docs to keep it small
      }) warnProblems;

      overrideHandlerString =
        indentation:
        concatMapStringsSep ("\n" + indentation) (
          problem: ''${escapeNixIdentifier pname}.${escapeNixIdentifier problem.name} = "warn";''
        ) errorProblems;

      error =
        if errorProblems == [ ] then
          null
        else
          {
            reason = "problem";
            errormsg = "has the following problems that must be acknowledged: [ ${
              concatMapStringsSep " " (attrs: "\"${attrs.name}\"") errorProblems
            } ]";
            ## TODO: Add mention of problem.matchers, or maybe better link to docs of that
            remediation = ''

              Package problems:

              ${concatMapStringsSep "\n" (x: "- ${fullMessage x}") errorProblems}

              You can use it anyway by ignoring its problems, using one of the
              following methods:

              a) For `nixos-rebuild` you can add "warn" or "ignore" entries to
                `nixpkgs.config.problems.handlers` inside configuration.nix,
                like this:

                  {
                    nixpkgs.config.problems.handlers = {
                      ${overrideHandlerString "        "}
                    };
                  }

              b) For `nix-env`, `nix-build`, `nix-shell` or any other Nix command you can add
                "warn" or "ignore" to `problems.handlers` in
                ~/.config/nixpkgs/config.nix, like this:

                  {
                    problems.handlers = {
                      ${overrideHandlerString "        "}
                    };
                  }
            '';
          };
    in
    {
      inherit error warnings;
    };

}
