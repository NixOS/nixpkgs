# Checks derivation meta and attrs for problems (like brokenness,
# licenses, etc).

{ lib, config, hostPlatform }:

let
  inherit (lib)
    all
    attrNames
    concatMapStrings
    concatMapStringsSep
    concatStrings
    findFirst
    isDerivation
    length
    concatMap
    mutuallyExclusive
    optional
    optionalAttrs
    optionalString
    optionals
    isAttrs
    isString
    mapAttrs
  ;

  inherit (lib.lists)
    any
    toList
    isList
    elem
  ;

  # If we're in hydra, we can dispense with the more verbose error
  # messages and make problems easier to spot.
  inHydra = config.inHydra or false;
  # Allow the user to opt-into additional warnings, e.g.
  # import <nixpkgs> { config = { showDerivationWarnings = [ "maintainerless" ]; }; }
  showWarnings = config.showDerivationWarnings;

  getName = attrs: attrs.name or ("${attrs.pname or "«name-missing»"}-${attrs.version or "«version-missing»"}");

  allowUnfree = config.allowUnfree
    || builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1";

  allowNonSource = let
    envVar = builtins.getEnv "NIXPKGS_ALLOW_NONSOURCE";
  in if envVar != ""
     then envVar != "0"
     else config.allowNonSource or true;

  allowlist = config.allowlistedLicenses or config.whitelistedLicenses or [];
  blocklist = config.blocklistedLicenses or config.blacklistedLicenses or [];

  areLicenseListsValid =
    if mutuallyExclusive allowlist blocklist then
      true
    else
      throw "allowlistedLicenses and blocklistedLicenses are not mutually exclusive.";

  hasLicense = attrs:
    attrs ? meta.license;

  hasListedLicense = assert areLicenseListsValid; list: attrs:
    length list > 0 && hasLicense attrs && (
      if isList attrs.meta.license then any (l: elem l list) attrs.meta.license
      else elem attrs.meta.license list
    );

  hasAllowlistedLicense = attrs: hasListedLicense allowlist attrs;

  hasBlocklistedLicense = attrs: hasListedLicense blocklist attrs;

  allowBroken = config.allowBroken
    || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1";

  allowUnsupportedSystem = config.allowUnsupportedSystem
    || builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM" == "1";

  isUnfree = licenses:
    if isAttrs licenses then !licenses.free or true
    # TODO: Returning false in the case of a string is a bug that should be fixed.
    # In a previous implementation of this function the function body
    # was `licenses: lib.lists.any (l: !l.free or true) licenses;`
    # which always evaluates to `!true` for strings.
    else if isString licenses then false
    else lib.lists.any (l: !l.free or true) licenses;

  hasUnfreeLicense = attrs: hasLicense attrs && isUnfree attrs.meta.license;

  hasNoMaintainers = attrs:
    attrs ? meta.maintainers && (length attrs.meta.maintainers) == 0;

  isMarkedBroken = attrs: attrs.meta.broken or false;

  hasUnsupportedPlatform =
    pkg: !(lib.meta.availableOn hostPlatform pkg);

  isMarkedInsecure = attrs: (attrs.meta.knownVulnerabilities or []) != [];

  # Alow granular checks to allow only some unfree packages
  # Example:
  # {pkgs, ...}:
  # {
  #   allowUnfree = false;
  #   allowUnfreePredicate = (x: pkgs.lib.hasPrefix "vscode" x.name);
  # }
  allowUnfreePredicate = config.allowUnfreePredicate or (x: false);

  # Check whether unfree packages are allowed and if not, whether the
  # package has an unfree license and is not explicitly allowed by the
  # `allowUnfreePredicate` function.
  hasDeniedUnfreeLicense = attrs:
    hasUnfreeLicense attrs &&
    !allowUnfree &&
    !allowUnfreePredicate attrs;

  allowInsecureDefaultPredicate = x: builtins.elem (getName x) (config.permittedInsecurePackages or []);
  allowInsecurePredicate = x: (config.allowInsecurePredicate or allowInsecureDefaultPredicate) x;

  hasAllowedInsecure = attrs:
    !(isMarkedInsecure attrs) ||
    allowInsecurePredicate attrs ||
    builtins.getEnv "NIXPKGS_ALLOW_INSECURE" == "1";


  isNonSource = sourceTypes: any (t: !t.isSource) sourceTypes;

  hasNonSourceProvenance = attrs:
    (attrs ? meta.sourceProvenance) &&
    isNonSource attrs.meta.sourceProvenance;

  # Allow granular checks to allow only some non-source-built packages
  # Example:
  # { pkgs, ... }:
  # {
  #   allowNonSource = false;
  #   allowNonSourcePredicate = with pkgs.lib.lists; pkg: !(any (p: !p.isSource && p != lib.sourceTypes.binaryFirmware) pkg.meta.sourceProvenance);
  # }
  allowNonSourcePredicate = config.allowNonSourcePredicate or (x: false);

  # Check whether non-source packages are allowed and if not, whether the
  # package has non-source provenance and is not explicitly allowed by the
  # `allowNonSourcePredicate` function.
  hasDeniedNonSourceProvenance = attrs:
    hasNonSourceProvenance attrs &&
    !allowNonSource &&
    !allowNonSourcePredicate attrs;

  showLicenseOrSourceType = value: toString (map (v: v.shortName or "unknown") (toList value));
  showLicense = showLicenseOrSourceType;
  showSourceType = showLicenseOrSourceType;

  pos_str = meta: meta.position or "«unknown-file»";

  remediation = {
    unfree = remediate_allowlist "Unfree" (remediate_predicate "allowUnfreePredicate");
    non-source = remediate_allowlist "NonSource" (remediate_predicate "allowNonSourcePredicate");
    broken = remediate_allowlist "Broken" (x: "");
    unsupported = remediate_allowlist "UnsupportedSystem" (x: "");
    blocklisted = x: "";
    insecure = remediate_insecure;
    broken-outputs = remediateOutputsToInstall;
    unknown-meta = x: "";
    maintainerless = x: "";
  };
  remediation_env_var = allow_attr: {
    Unfree = "NIXPKGS_ALLOW_UNFREE";
    Broken = "NIXPKGS_ALLOW_BROKEN";
    UnsupportedSystem = "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM";
    NonSource = "NIXPKGS_ALLOW_NONSOURCE";
  }.${allow_attr};
  remediation_phrase = allow_attr: {
    Unfree = "unfree packages";
    Broken = "broken packages";
    UnsupportedSystem = "packages that are unsupported for this system";
    NonSource = "packages not built from source";
  }.${allow_attr};
  remediate_predicate = predicateConfigAttr: attrs:
    ''

      Alternatively you can configure a predicate to allow specific packages:
        { nixpkgs.config.${predicateConfigAttr} = pkg: builtins.elem (lib.getName pkg) [
            "${getName attrs}"
          ];
        }
    '';

    # flakeNote will be printed in the remediation messages below.
    flakeNote = "
   Note: When using `nix shell`, `nix build`, `nix develop`, etc with a flake,
         then pass `--impure` in order to allow use of environment variables.
    ";

  remediate_allowlist = allow_attr: rebuild_amendment: attrs:
    ''
      a) To temporarily allow ${remediation_phrase allow_attr}, you can use an environment variable
         for a single invocation of the nix tools.

           $ export ${remediation_env_var allow_attr}=1
           ${flakeNote}
      b) For `nixos-rebuild` you can set
        { nixpkgs.config.allow${allow_attr} = true; }
      in configuration.nix to override this.
      ${rebuild_amendment attrs}
      c) For `nix-env`, `nix-build`, `nix-shell` or any other Nix command you can add
        { allow${allow_attr} = true; }
      to ~/.config/nixpkgs/config.nix.
    '';

  remediate_insecure = attrs:
    ''

      Known issues:
    '' + (concatStrings (map (issue: " - ${issue}\n") attrs.meta.knownVulnerabilities)) + ''

        You can install it anyway by allowing this package, using the
        following methods:

        a) To temporarily allow all insecure packages, you can use an environment
           variable for a single invocation of the nix tools:

             $ export NIXPKGS_ALLOW_INSECURE=1
             ${flakeNote}
        b) for `nixos-rebuild` you can add ‘${getName attrs}’ to
           `nixpkgs.config.permittedInsecurePackages` in the configuration.nix,
           like so:

             {
               nixpkgs.config.permittedInsecurePackages = [
                 "${getName attrs}"
               ];
             }

        c) For `nix-env`, `nix-build`, `nix-shell` or any other Nix command you can add
           ‘${getName attrs}’ to `permittedInsecurePackages` in
           ~/.config/nixpkgs/config.nix, like so:

             {
               permittedInsecurePackages = [
                 "${getName attrs}"
               ];
             }

      '';

  remediateOutputsToInstall = attrs: let
      expectedOutputs = attrs.meta.outputsToInstall or [];
      actualOutputs = attrs.outputs or [ "out" ];
      missingOutputs = builtins.filter (output: ! builtins.elem output actualOutputs) expectedOutputs;
    in ''
      The package ${getName attrs} has set meta.outputsToInstall to: ${builtins.concatStringsSep ", " expectedOutputs}

      however ${getName attrs} only has the outputs: ${builtins.concatStringsSep ", " actualOutputs}

      and is missing the following ouputs:

      ${concatStrings (builtins.map (output: "  - ${output}\n") missingOutputs)}
    '';

  handleEvalIssue = { meta, attrs }: { reason , errormsg ? "" }:
    let
      msg = if inHydra
        then "Failed to evaluate ${getName attrs}: «${reason}»: ${errormsg}"
        else ''
          Package ‘${getName attrs}’ in ${pos_str meta} ${errormsg}, refusing to evaluate.

        '' + (builtins.getAttr reason remediation) attrs;

      handler = if config ? handleEvalIssue
        then config.handleEvalIssue reason
        else throw;
    in handler msg;

  handleEvalWarning = { meta, attrs }: { reason , errormsg ? "" }:
    let
      remediationMsg = (builtins.getAttr reason remediation) attrs;
      msg = if inHydra then "Warning while evaluating ${getName attrs}: «${reason}»: ${errormsg}"
        else "Package ${getName attrs} in ${pos_str meta} ${errormsg}, continuing anyway."
             + (optionalString (remediationMsg != "") "\n${remediationMsg}");
      isEnabled = findFirst (x: x == reason) null showWarnings;
    in if isEnabled != null then builtins.trace msg true else true;

  metaTypes = let
    types = import ./meta-types.nix { inherit lib; };
    inherit (types) str union int attrs attrsOf any listOf bool;
    platforms = listOf (union [ str (attrsOf any) ]);  # see lib.meta.platformMatch
  in {
    # These keys are documented
    description = str;
    mainProgram = str;
    longDescription = str;
    branch = str;
    homepage = union [
      (listOf str)
      str
    ];
    downloadPage = str;
    changelog = union [
      (listOf str)
      str
    ];
    license = let
      # TODO disallow `str` licenses, use a module
      licenseType = union [
        (attrsOf any)
        str
      ];
    in union [
      (listOf licenseType)
      licenseType
    ];
    sourceProvenance = listOf attrs;
    maintainers = listOf (attrsOf any); # TODO use the maintainer type from lib/tests/maintainer-module.nix
    priority = int;
    pkgConfigModules = listOf str;
    inherit platforms;
    hydraPlatforms = listOf str;
    broken = bool;
    unfree = bool;
    unsupported = bool;
    insecure = bool;
    tests = {
      name = "test";
      verify = x: x == {} || ( # Accept {} for tests that are unsupported
        isDerivation x &&
        x ? meta.timeout
      );
    };
    timeout = int;

    # Needed for Hydra to expose channel tarballs:
    # https://github.com/NixOS/hydra/blob/53335323ae79ca1a42643f58e520b376898ce641/doc/manual/src/jobs.md#meta-fields
    isHydraChannel = bool;

    # Weirder stuff that doesn't appear in the documentation?
    maxSilent = int;
    knownVulnerabilities = listOf str;
    name = str;
    version = str;
    tag = str;
    executables = listOf str;
    outputsToInstall = listOf str;
    position = str;
    available = any;
    isBuildPythonPackage = platforms;
    schedulingPriority = int;
    isFcitxEngine = bool;
    isIbusEngine = bool;
    isGutenprint = bool;
    badPlatforms = platforms;
  };

  checkMetaAttr = let
    # Map attrs directly to the verify function for performance
    metaTypes' = mapAttrs (_: t: t.verify) metaTypes;
  in k: v:
    if metaTypes?${k} then
      if metaTypes'.${k} v then
        [ ]
      else
        [ "key 'meta.${k}' has invalid value; expected ${metaTypes.${k}.name}, got\n    ${
          lib.generators.toPretty { indent = "    "; } v
        }" ]
    else
      [ "key 'meta.${k}' is unrecognized; expected one of: \n  [${concatMapStringsSep ", " (x: "'${x}'") (attrNames metaTypes)}]" ];
  checkMeta = meta: optionals config.checkMeta (concatMap (attr: checkMetaAttr attr meta.${attr}) (attrNames meta));

  checkOutputsToInstall = attrs: let
      expectedOutputs = attrs.meta.outputsToInstall or [];
      actualOutputs = attrs.outputs or [ "out" ];
      missingOutputs = builtins.filter (output: ! builtins.elem output actualOutputs) expectedOutputs;
    in if config.checkMeta
       then builtins.length missingOutputs > 0
       else false;

  # Check if a derivation is valid, that is whether it passes checks for
  # e.g brokenness or license.
  #
  # Return { valid: "yes", "warn" or "no" } and additionally
  # { reason: String; errormsg: String } if it is not valid, where
  # reason is one of "unfree", "blocklisted", "broken", "insecure", ...
  # !!! reason strings are hardcoded into OfBorg, make sure to keep them in sync
  # Along with a boolean flag for each reason
  checkValidity = attrs:
    # Check meta attribute types first, to make sure it is always called even when there are other issues
    # Note that this is not a full type check and functions below still need to by careful about their inputs!
    let res = checkMeta (attrs.meta or {}); in if res != [] then
      { valid = "no"; reason = "unknown-meta"; errormsg = "has an invalid meta attrset:${concatMapStrings (x: "\n  - " + x) res}\n";
        unfree = false; nonSource = false; broken = false; unsupported = false; insecure = false;
      }
    else {
      unfree = hasUnfreeLicense attrs;
      nonSource = hasNonSourceProvenance attrs;
      broken = isMarkedBroken attrs;
      unsupported = hasUnsupportedPlatform attrs;
      insecure = isMarkedInsecure attrs;
    } // (
    # --- Put checks that cannot be ignored here ---
    if checkOutputsToInstall attrs then
      { valid = "no"; reason = "broken-outputs"; errormsg = "has invalid meta.outputsToInstall"; }

    # --- Put checks that can be ignored here ---
    else if hasDeniedUnfreeLicense attrs && !(hasAllowlistedLicense attrs) then
      { valid = "no"; reason = "unfree"; errormsg = "has an unfree license (‘${showLicense attrs.meta.license}’)"; }
    else if hasBlocklistedLicense attrs then
      { valid = "no"; reason = "blocklisted"; errormsg = "has a blocklisted license (‘${showLicense attrs.meta.license}’)"; }
    else if hasDeniedNonSourceProvenance attrs then
      { valid = "no"; reason = "non-source"; errormsg = "contains elements not built from source (‘${showSourceType attrs.meta.sourceProvenance}’)"; }
    else if !allowBroken && attrs.meta.broken or false then
      { valid = "no"; reason = "broken"; errormsg = "is marked as broken"; }
    else if !allowUnsupportedSystem && hasUnsupportedPlatform attrs then
      let toPretty = lib.generators.toPretty {
            allowPrettyValues = true;
            indent = "  ";
          };
      in { valid = "no"; reason = "unsupported";
           errormsg = ''
             is not available on the requested hostPlatform:
               hostPlatform.config = "${hostPlatform.config}"
               package.meta.platforms = ${toPretty (attrs.meta.platforms or [])}
               package.meta.badPlatforms = ${toPretty (attrs.meta.badPlatforms or [])}
            '';
         }
    else if !(hasAllowedInsecure attrs) then
      { valid = "no"; reason = "insecure"; errormsg = "is marked as insecure"; }

    # --- warnings ---
    # Please also update the type in /pkgs/top-level/config.nix alongside this.
    else if hasNoMaintainers attrs then
      { valid = "warn"; reason = "maintainerless"; errormsg = "has no maintainers"; }
    # -----
    else { valid = "yes"; });


  # The meta attribute is passed in the resulting attribute set,
  # but it's not part of the actual derivation, i.e., it's not
  # passed to the builder and is not a dependency.  But since we
  # include it in the result, it *is* available to nix-env for queries.
  # Example:
  #   meta = checkMeta.commonMeta { inherit validity attrs pos references; };
  #   validity = checkMeta.assertValidity { inherit meta attrs; };
  commonMeta = { validity, attrs, pos ? null, references ? [ ] }:
    let
      outputs = attrs.outputs or [ "out" ];
    in
    {
      # `name` derivation attribute includes cross-compilation cruft,
      # is under assert, and is sanitized.
      # Let's have a clean always accessible version here.
      name = attrs.name or "${attrs.pname}-${attrs.version}";

      # If the packager hasn't specified `outputsToInstall`, choose a default,
      # which is the name of `p.bin or p.out or p` along with `p.man` when
      # present.
      #
      # If the packager has specified it, it will be overridden below in
      # `// meta`.
      #
      #   Note: This default probably shouldn't be globally configurable.
      #   Services and users should specify outputs explicitly,
      #   unless they are comfortable with this default.
      outputsToInstall =
        let
          hasOutput = out: builtins.elem out outputs;
        in
        [ (findFirst hasOutput null ([ "bin" "out" ] ++ outputs)) ]
        ++ optional (hasOutput "man") "man";
    }
    // attrs.meta or { }
    # Fill `meta.position` to identify the source location of the package.
    // optionalAttrs (pos != null) {
      position = pos.file + ":" + toString pos.line;
    } // {
      # Expose the result of the checks for everyone to see.
      inherit (validity) unfree broken unsupported insecure;

      available = validity.valid != "no"
      && (if config.checkMetaRecursively or false
      then all (d: d.meta.available or true) references
      else true);
    };

  assertValidity = { meta, attrs }: let
      validity = checkValidity attrs;
      inherit (validity) valid;
  in validity // {
      # Throw an error if trying to evaluate a non-valid derivation
      # or, alternatively, just output a warning message.
      handled =
        (
          if valid == "yes" then true
          else if valid == "no" then (
            handleEvalIssue { inherit meta attrs; } { inherit (validity) reason errormsg; }
          )
          else if valid == "warn" then (
            handleEvalWarning { inherit meta attrs; } { inherit (validity) reason errormsg; }
          )
          else throw "Unknown validitiy: '${valid}'"
        );
  };

in { inherit assertValidity commonMeta; }
