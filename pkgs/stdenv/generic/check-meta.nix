# Checks derivation meta and attrs for problems (like brokenness,
# licenses, etc).

{ lib, config, hostPlatform }:

let
  # If we're in hydra, we can dispense with the more verbose error
  # messages and make problems easier to spot.
  inHydra = config.inHydra or false;
  # Allow the user to opt-into additional warnings, e.g.
  # import <nixpkgs> { config = { showDerivationWarnings = [ "maintainerless" ]; }; }
  showWarnings = config.showDerivationWarnings;

  getName = attrs: attrs.name or ("${attrs.pname or "«name-missing»"}-${attrs.version or "«version-missing»"}");

  # See discussion at https://github.com/NixOS/nixpkgs/pull/25304#issuecomment-298385426
  # for why this defaults to false, but I (@copumpkin) want to default it to true soon.
  shouldCheckMeta = config.checkMeta or false;

  allowUnfree = config.allowUnfree
    || builtins.getEnv "NIXPKGS_ALLOW_UNFREE" == "1";

  allowNonSource = config.allowNonSource or true
    && builtins.getEnv "NIXPKGS_ALLOW_NONSOURCE" != "0";

  allowlist = config.allowlistedLicenses or config.whitelistedLicenses or [];
  blocklist = config.blocklistedLicenses or config.blacklistedLicenses or [];

  areLicenseListsValid =
    if lib.mutuallyExclusive allowlist blocklist then
      true
    else
      throw "allowlistedLicenses and blocklistedLicenses are not mutually exclusive.";

  hasLicense = attrs:
    attrs ? meta.license;

  hasAllowlistedLicense = assert areLicenseListsValid; attrs:
    hasLicense attrs && lib.lists.any (l: builtins.elem l allowlist) (lib.lists.toList attrs.meta.license);

  hasBlocklistedLicense = assert areLicenseListsValid; attrs:
    hasLicense attrs && lib.lists.any (l: builtins.elem l blocklist) (lib.lists.toList attrs.meta.license);

  allowBroken = config.allowBroken
    || builtins.getEnv "NIXPKGS_ALLOW_BROKEN" == "1";

  allowUnsupportedSystem = config.allowUnsupportedSystem
    || builtins.getEnv "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM" == "1";

  isUnfree = licenses: lib.lists.any (l: !l.free or true) licenses;

  hasUnfreeLicense = attrs:
    hasLicense attrs &&
    isUnfree (lib.lists.toList attrs.meta.license);

  hasNoMaintainers = attrs:
    attrs ? meta.maintainers && (lib.length attrs.meta.maintainers) == 0;

  isMarkedBroken = attrs: attrs.meta.broken or false;

  hasUnsupportedPlatform = attrs:
    (!lib.lists.elem hostPlatform.system (attrs.meta.platforms or lib.platforms.all) ||
      lib.lists.elem hostPlatform.system (attrs.meta.badPlatforms or []));

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
  # package has an unfree license and is not explicitely allowed by the
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
    config.allowInsecurePackages ||
    builtins.getEnv "NIXPKGS_ALLOW_INSECURE" == "1";


  isNonSource = sourceTypes: lib.lists.any (t: !t.isSource) sourceTypes;

  hasNonSourceProvenance = attrs:
    (attrs ? meta.sourceProvenance) &&
    isNonSource (lib.lists.toList attrs.meta.sourceProvenance);

  # Allow granular checks to allow only some non-source-built packages
  # Example:
  # { pkgs, ... }:
  # {
  #   allowNonSource = false;
  #   allowNonSourcePredicate = with pkgs.lib.lists; pkg: !(any (p: !p.isSource && p != lib.sourceTypes.binaryFirmware) (toList pkg.meta.sourceProvenance));
  # }
  allowNonSourcePredicate = config.allowNonSourcePredicate or (x: false);

  # Check whether non-source packages are allowed and if not, whether the
  # package has non-source provenance and is not explicitly allowed by the
  # `allowNonSourcePredicate` function.
  hasDeniedNonSourceProvenance = attrs:
    hasNonSourceProvenance attrs &&
    !allowNonSource &&
    !allowNonSourcePredicate attrs;

  showLicenseOrSourceType = value: toString (map (v: v.shortName or "unknown") (lib.lists.toList value));
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
            "${lib.getName attrs}"
          ];
        }
    '';

    # flakeNote will be printed in the remediation messages below.
    flakeNote = "
 Note: For `nix shell`, `nix build`, `nix develop` or any other Nix 2.4+
 (Flake) command, `--impure` must be passed in order to read this
 environment variable.
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
    '' + (lib.concatStrings (map (issue: " - ${issue}\n") attrs.meta.knownVulnerabilities)) + ''

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

      ${lib.concatStrings (builtins.map (output: "  - ${output}\n") missingOutputs)}
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
             + (if remediationMsg != "" then "\n${remediationMsg}" else "");
      isEnabled = lib.findFirst (x: x == reason) null showWarnings;
    in if isEnabled != null then builtins.trace msg true else true;

  metaTypes = with lib.types; rec {
    # These keys are documented
    description = str;
    mainProgram = str;
    longDescription = str;
    branch = str;
    homepage = either (listOf str) str;
    downloadPage = str;
    changelog = either (listOf str) str;
    license = either (listOf lib.types.attrs) (either lib.types.attrs str);
    sourceProvenance = either (listOf lib.types.attrs) lib.types.attrs;
    maintainers = listOf (attrsOf str);
    priority = int;
    platforms = listOf str;
    hydraPlatforms = listOf str;
    broken = bool;
    unfree = bool;
    unsupported = bool;
    insecure = bool;
    # TODO: refactor once something like Profpatsch's types-simple will land
    # This is currently dead code due to https://github.com/NixOS/nix/issues/2532
    tests = attrsOf (mkOptionType {
      name = "test";
      check = x: x == {} || ( # Accept {} for tests that are unsupported
        isDerivation x &&
        x ? meta.timeout
      );
      merge = lib.options.mergeOneOption;
    });
    timeout = int;

    # Weirder stuff that doesn't appear in the documentation?
    maxSilent = int;
    knownVulnerabilities = listOf str;
    name = str;
    version = str;
    tag = str;
    executables = listOf str;
    outputsToInstall = listOf str;
    position = str;
    available = bool;
    isBuildPythonPackage = platforms;
    schedulingPriority = int;
    isFcitxEngine = bool;
    isIbusEngine = bool;
    isGutenprint = bool;
    badPlatforms = platforms;
  };

  checkMetaAttr = k: v:
    if metaTypes?${k} then
      if metaTypes.${k}.check v then null else "key '${k}' has a value ${toString v} of an invalid type ${builtins.typeOf v}; expected ${metaTypes.${k}.description}"
    else "key '${k}' is unrecognized; expected one of: \n\t      [${lib.concatMapStringsSep ", " (x: "'${x}'") (lib.attrNames metaTypes)}]";
  checkMeta = meta: if shouldCheckMeta then lib.remove null (lib.mapAttrsToList checkMetaAttr meta) else [];

  checkOutputsToInstall = attrs: let
      expectedOutputs = attrs.meta.outputsToInstall or [];
      actualOutputs = attrs.outputs or [ "out" ];
      missingOutputs = builtins.filter (output: ! builtins.elem output actualOutputs) expectedOutputs;
    in if shouldCheckMeta
       then builtins.length missingOutputs > 0
       else false;

  # Check if a derivation is valid, that is whether it passes checks for
  # e.g brokenness or license.
  #
  # Return { valid: Bool } and additionally
  # { reason: String; errormsg: String } if it is not valid, where
  # reason is one of "unfree", "blocklisted", "broken", "insecure", ...
  # Along with a boolean flag for each reason
  checkValidity = attrs:
    {
      unfree = hasUnfreeLicense attrs;
      nonSource = hasNonSourceProvenance attrs;
      broken = isMarkedBroken attrs;
      unsupported = hasUnsupportedPlatform attrs;
      insecure = isMarkedInsecure attrs;
    }
    // (if hasDeniedUnfreeLicense attrs && !(hasAllowlistedLicense attrs) then
      { valid = "no"; reason = "unfree"; errormsg = "has an unfree license (‘${showLicense attrs.meta.license}’)"; }
    else if hasBlocklistedLicense attrs then
      { valid = "no"; reason = "blocklisted"; errormsg = "has a blocklisted license (‘${showLicense attrs.meta.license}’)"; }
    else if hasDeniedNonSourceProvenance attrs then
      { valid = "no"; reason = "non-source"; errormsg = "contains elements not built from source (‘${showSourceType attrs.meta.sourceProvenance}’)"; }
    else if !allowBroken && attrs.meta.broken or false then
      { valid = "no"; reason = "broken"; errormsg = "is marked as broken"; }
    else if !allowUnsupportedSystem && hasUnsupportedPlatform attrs then
      { valid = "no"; reason = "unsupported"; errormsg = "is not supported on ‘${hostPlatform.system}’"; }
    else if !(hasAllowedInsecure attrs) then
      { valid = "no"; reason = "insecure"; errormsg = "is marked as insecure"; }
    else if checkOutputsToInstall attrs then
      { valid = "no"; reason = "broken-outputs"; errormsg = "has invalid meta.outputsToInstall"; }
    else let res = checkMeta (attrs.meta or {}); in if res != [] then
      { valid = "no"; reason = "unknown-meta"; errormsg = "has an invalid meta attrset:${lib.concatMapStrings (x: "\n\t - " + x) res}"; }
    # --- warnings ---
    # Please also update the type in /pkgs/top-level/config.nix alongside this.
    else if hasNoMaintainers attrs then
      { valid = "warn"; reason = "maintainerless"; errormsg = "has no maintainers"; }
    # -----
    else { valid = "yes"; });

  assertValidity = { meta, attrs }: let
      validity = checkValidity attrs;
    in validity // {
      # Throw an error if trying to evaluate a non-valid derivation
      # or, alternatively, just output a warning message.
      handled =
        {
          no = handleEvalIssue { inherit meta attrs; } { inherit (validity) reason errormsg; };
          warn = handleEvalWarning { inherit meta attrs; } { inherit (validity) reason errormsg; };
          yes = true;
        }.${validity.valid};
  };

in assertValidity
