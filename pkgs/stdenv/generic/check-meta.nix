# Checks derivation meta and attrs for problems (like brokenness,
# licenses, etc).

{ lib, config, hostPlatform, meta }:

let
  onlyLicenses = list:
    lib.lists.all (license:
      let l = lib.licenses.${license.shortName or "BROKEN"} or false; in
      if license == l then true else
        throw ''‘${showLicense license}’ is not an attribute of lib.licenses''
    ) list;

  areLicenseListsValid =
    if lib.mutuallyExclusive config.whitelistedLicenses config.blacklistedLicenses then
      assert onlyLicenses config.whitelistedLicenses; assert onlyLicenses config.blacklistedLicenses; true
    else
      throw "whitelistedLicenses and blacklistedLicenses are not mutually exclusive.";

  hasLicense = attrs:
    attrs ? meta.license;

  hasWhitelistedLicense = assert areLicenseListsValid; attrs:
    hasLicense attrs && builtins.elem attrs.meta.license config.whitelistedLicenses;

  hasBlacklistedLicense = assert areLicenseListsValid; attrs:
    hasLicense attrs && builtins.elem attrs.meta.license config.blacklistedLicenses;

  isUnfree = licenses: lib.lists.any (l: !l.free or true) licenses;

  # Check whether unfree packages are allowed and if not, whether the
  # package has an unfree license and is not explicitely allowed by the
  # `allowUnfreePredicate` function.
  hasDeniedUnfreeLicense = attrs:
    !config.allowUnfree &&
    hasLicense attrs &&
    isUnfree (lib.lists.toList attrs.meta.license) &&
    !(config.allowUnfreePredicate attrs);

  hasAllowedInsecure = attrs:
    (attrs.meta.knownVulnerabilities or []) == [] ||
    config.allowInsecure ||
    config.allowInsecurePredicate attrs;

  showLicense = license: license.shortName or "unknown";

  pos_str = meta.position or "«unknown-file»";

  remediation = {
    broken = remediate_whitelist "Broken" false;
    unsupported = remediate_whitelist "UnsupportedSystem" false;
    blacklisted = x: "";
    unfree = remediate_unfree;
    insecure = remediate_insecure;
    broken-outputs = remediateOutputsToInstall;
    unknown-meta = x: "";
  };

  remediate_whitelist = allow_attr: permitted: attrs: let
    name = attrs.name or "«name-missing»";
  in ''
      a) For `nixos-rebuild` you can set
    '' + (lib.optionalString permitted ''

         {
           nixpkgs.config.permitted${allow_attr}Packages = [
             "${name}"
           ];
         }
      or
    '') + ''
         { nixpkgs.config.allow${allow_attr} = true; }

      in configuration.nix to override this.

    '' + ''
      b) For `nix-env`, `nix-build`, `nix-shell` or any other Nix command you can add
    '' + (lib.optionalString permitted ''

         {
           permitted${allow_attr}Packages = [
             "${name}"
           ];
         }
      or
    '') + ''
        { allow${allow_attr} = true; }

      to ~/.config/nixpkgs/config.nix.
    '';

  remediate_unfree = attrs:
    ''
      This package is unfree, but you can install it anyway by using one of the following methods:

    '' + (remediate_whitelist "Unfree" true attrs);

  remediate_insecure = attrs:
    ''
      Known issues:

    '' + (lib.concatStrings (map (issue: " - ${issue}\n") attrs.meta.knownVulnerabilities)) + ''

      You can install it anyway by using one of the following methods:

    '' + (remediate_whitelist "Insecure" true attrs);

  remediateOutputsToInstall = attrs: let
      expectedOutputs = attrs.meta.outputsToInstall or [];
      actualOutputs = attrs.outputs or [ "out" ];
      missingOutputs = builtins.filter (output: ! builtins.elem output actualOutputs) expectedOutputs;
    in ''
      The package ${attrs.name} has set meta.outputsToInstall to: ${builtins.concatStringsSep ", " expectedOutputs}

      however ${attrs.name} only has the outputs: ${builtins.concatStringsSep ", " actualOutputs}

      and is missing the following ouputs:

      ${lib.concatStrings (builtins.map (output: "  - ${output}\n") missingOutputs)}
    '';

  handleEvalIssue = attrs: { reason , errormsg ? "" }:
    let
      msg = if config.inHydra
        then "Failed to evaluate ${attrs.name or "«name-missing»"}: «${reason}»: ${errormsg}"
        else ''
          Package ‘${attrs.name or "«name-missing»"}’ in ${pos_str} ${errormsg}, refusing to evaluate.

        '' + (builtins.getAttr reason remediation) attrs;

      handler = if config ? "handleEvalIssue"
        then config.handleEvalIssue reason
        else throw;
    in handler msg;


  metaTypes = with lib.types; rec {
    # These keys are documented
    description = str;
    longDescription = str;
    branch = str;
    homepage = either (listOf str) str;
    downloadPage = str;
    license = either (listOf lib.types.attrs) (either lib.types.attrs str);
    maintainers = listOf (attrsOf str);
    priority = int;
    platforms = listOf (either str lib.systems.parsedPlatform.types.system);
    hydraPlatforms = listOf str;
    broken = bool;
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
    knownVulnerabilities = listOf str;
    name = str;
    version = str;
    tag = str;
    updateWalker = bool;
    executables = listOf str;
    outputsToInstall = listOf str;
    position = str;
    available = bool;
    repositories = attrsOf str;
    isBuildPythonPackage = platforms;
    schedulingPriority = int;
    downloadURLRegexp = str;
    isFcitxEngine = bool;
    isIbusEngine = bool;
    isGutenprint = bool;
    badPlatforms = platforms;
  };

  checkMetaAttr = k: v:
    if metaTypes?${k} then
      if metaTypes.${k}.check v then null else "key '${k}' has a value ${toString v} of an invalid type ${builtins.typeOf v}; expected ${metaTypes.${k}.description}"
    else "key '${k}' is unrecognized; expected one of: \n\t      [${lib.concatMapStringsSep ", " (x: "'${x}'") (lib.attrNames metaTypes)}]";

  checkMeta = meta: if config.checkMeta then lib.remove null (lib.mapAttrsToList checkMetaAttr meta) else [];

  checkPlatform = attrs: let
      anyMatch = lib.any (lib.meta.platformMatch hostPlatform);
    in  anyMatch (attrs.meta.platforms or lib.platforms.all) &&
      ! anyMatch (attrs.meta.badPlatforms or []);

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
  # Return { valid: Bool } and additionally
  # { reason: String; errormsg: String } if it is not valid, where
  # reason is one of "unfree", "blacklisted" or "broken".
  checkValidity = attrs:
    if hasDeniedUnfreeLicense attrs && !(hasWhitelistedLicense attrs) then
      { valid = false; reason = "unfree"; errormsg = "has an unfree license (‘${showLicense attrs.meta.license}’)"; }
    else if hasBlacklistedLicense attrs then
      { valid = false; reason = "blacklisted"; errormsg = "has a blacklisted license (‘${showLicense attrs.meta.license}’)"; }
    else if !config.allowBroken && attrs.meta.broken or false then
      { valid = false; reason = "broken"; errormsg = "is marked as broken"; }
    else if !config.allowUnsupportedSystem && !(checkPlatform attrs) then
      { valid = false; reason = "unsupported"; errormsg = "is not supported on ‘${hostPlatform.config}’"; }
    else if !(hasAllowedInsecure attrs) then
      { valid = false; reason = "insecure"; errormsg = "is marked as insecure"; }
    else if checkOutputsToInstall attrs then
      { valid = false; reason = "broken-outputs"; errormsg = "has invalid meta.outputsToInstall"; }
    else let res = checkMeta (attrs.meta or {}); in if res != [] then
      { valid = false; reason = "unknown-meta"; errormsg = "has an invalid meta attrset:${lib.concatMapStrings (x: "\n\t - " + x) res}"; }
    else { valid = true; };

  assertValidity = attrs: let
      validity = checkValidity attrs;
    in validity // {
      # Throw an error if trying to evaluate an non-valid derivation
      handled = if !validity.valid
        then handleEvalIssue attrs (removeAttrs validity ["valid"])
        else true;
  };

in assertValidity
