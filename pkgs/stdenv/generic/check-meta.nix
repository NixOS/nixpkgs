# Checks derivation meta and attrs for problems (like brokenness,
# licenses, etc).

{ lib, config, hostPlatform, meta }:

let
  hasLicense = attrs:
    attrs ? meta.license;

  hasWhitelistedLicense = attrs:
    hasLicense attrs &&
    builtins.elem attrs.meta.license config.whitelistedLicenses;

  hasBlacklistedLicense = attrs:
    hasLicense attrs &&
    builtins.elem attrs.meta.license config.blacklistedLicenses;

  isUnfree = licenses: lib.lists.any (l:
    !l.free or true || l == "unfree" || l == "unfree-redistributable") licenses;

  # Check whether unfree packages are allowed and if not, whether the
  # package has an unfree license and is not explicitely allowed by the
  # `allowUNfreePredicate` function.
  hasDeniedUnfreeLicense = attrs:
    hasLicense attrs &&
    isUnfree (lib.lists.toList attrs.meta.license) &&
    !config.allowUnfreePredicate attrs;

  pos_str = meta.position or "«unknown-file»";

  remediation = (let
    whitelist = str: attrs: ''

        a) For `nixos-rebuild` you can set:

        { nixpkgs.config.${str}; }

           in configuration.nix to override this.

        b) For `nix-env`, `nix-build`, `nix-shell` or any other Nix
           command you can add:

        { ${str}; }

           to ~/.config/nixpkgs/config.nix.
      '';

    insecure = attrs: ''

      Known issues:

    '' + (lib.concatStrings (map (issue: " - ${issue}\n")
                                 attrs.meta.knownVulnerabilities)) + ''

        You can install it anyway by whitelisting this package, using
        the following methods:

        a) for `nixos-rebuild` you can add ‘${attrs.name}’ to
           `nixpkgs.config.permittedInsecurePackages` in the
           configuration.nix, like so:

             {
               nixpkgs.config.permittedInsecurePackages = [
                 "${attrs.name}"
               ];
             }

        b) For `nix-env`, `nix-build`, `nix-shell` or any other Nix
           command you can add ‘${attrs.name}’ to
           `permittedInsecurePackages` in
           ~/.config/nixpkgs/config.nix, like so:

             {
               permittedInsecurePackages = [
                 "${attrs.name}"
               ];
             }
    '';

  in {
    unfree = whitelist "allowUnfree = true";
    broken = whitelist "allowBroken = true";
    unsupported = whitelist "allowUnsupportedSystem = true";
    inherit insecure;
  });

  handleEvalIssue = attrs: { reason , errormsg ? "" }: config.handleEvalIssue ''

Package ‘${attrs.name or "«name-missing»"}’ in ${pos_str} ${errormsg},
refusing to evaluate.

${(remediation.${reason} or (_: "")) attrs}
  '';

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
    # Hydra build timeout
    timeout = int;
  };

  checkMetaAttr = k: v:
    if metaTypes?${k} then
      if metaTypes.${k}.check v then null
      else "key '${k}' has a value ${toString v} of an invalid type ${builtins.typeOf v}; expected ${metaTypes.${k}.description}"
    else "key '${k}' is unrecognized; expected one of: \n\t      [${lib.concatMapStringsSep ", " (x: "'${x}'") (lib.attrNames metaTypes)}]";
  checkMeta = meta: if config.checkMeta
                    then lib.remove null (lib.mapAttrsToList checkMetaAttr meta)
                    else [];

  checkPlatform = attrs: let
      anyMatch = lib.any (lib.meta.platformMatch hostPlatform);
    in  anyMatch (attrs.meta.platforms or lib.platforms.all) &&
      ! anyMatch (attrs.meta.badPlatforms or []);

  # Check if a derivation is valid, that is whether it passes checks for
  # e.g brokenness or license.
  #
  # Return { valid: Bool } and additionally
  # { reason: String; errormsg: String } if it is not valid, where
  # reason is one of "unfree", "blacklisted" or "broken".
  checkValidity = attrs:
    if hasDeniedUnfreeLicense attrs && !(hasWhitelistedLicense attrs) then {
      valid = false;
      reason = "unfree";
      errormsg = "has an unfree license (‘${attrs.meta.license.shortName or "unknown"}’)";
    } else if hasBlacklistedLicense attrs then {
      valid = false;
      reason = "blacklisted";
      errormsg = "has a blacklisted license (‘${attrs.meta.license.shortName or "unknown"}’)";
    } else if !config.allowBroken && attrs.meta.broken or false then {
      valid = false;
      reason = "broken";
      errormsg = "is marked as broken";
    } else if !config.allowUnsupportedSystem && !(checkPlatform attrs) then {
      valid = false;
      reason = "unsupported";
      errormsg = "is not supported on ‘${hostPlatform.config}’";
    } else if !(((attrs.meta.knownVulnerabilities or []) == []) ||
                 (config.allowInsecurePredicate attrs)) then {
      valid = false;
      reason = "insecure";
      errormsg = "is marked as insecure";
    } else let res = checkMeta (attrs.meta or {}); in if res != [] then {
      valid = false;
      errormsg = ''
        has an invalid meta attrset:
          ${lib.concatMapStrings (x: "\n\t - " + x) res}
      '';
    } else { valid = true; };

  assertValidity = attrs: let
      validity = checkValidity attrs;
    in validity // {
      # Throw an error if trying to evaluate an non-valid derivation
      handled = if !validity.valid
        then handleEvalIssue attrs (removeAttrs validity ["valid"])
        else true;
  };

in assertValidity
