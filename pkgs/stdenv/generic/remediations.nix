{ lib }:
let
  inherit (builtins)
    filter
    elem
    ;

  inherit (lib)
    getName
    concatStrings
    concatStringsSep
    ;

  getNameWithVersion =
    attrs: attrs.name or "${attrs.pname or "«name-missing»"}-${attrs.version or "«version-missing»"}";

  remediation_env_var =
    allow_attr:
    {
      Unfree = "NIXPKGS_ALLOW_UNFREE";
      UnsupportedSystem = "NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM";
      NonSource = "NIXPKGS_ALLOW_NONSOURCE";
    }
    .${allow_attr};
  remediation_phrase =
    allow_attr:
    {
      Unfree = "unfree packages";
      UnsupportedSystem = "packages that are unsupported for this system";
      NonSource = "packages not built from source";
    }
    .${allow_attr};
  # flakeNote will be printed in the remediation messages below.
  flakeNote = "
   Note: When using `nix shell`, `nix build`, `nix develop`, etc with a flake,
         then pass `--impure` in order to allow use of environment variables.
    ";

in
{
  inherit getNameWithVersion;
  remediateOutputsToInstall =
    attrs:
    let
      expectedOutputs =
        (
          attrs:
          let
            expectedOutputs = attrs.meta.outputsToInstall or [ ];
            actualOutputs = attrs.outputs or [ "out" ];
            missingOutputs = filter (output: !elem output actualOutputs) expectedOutputs;
          in
          ''
            The package ${getNameWithVersion attrs} has set meta.outputsToInstall to: ${concatStringsSep ", " expectedOutputs}

            however ${getNameWithVersion attrs} only has the outputs: ${concatStringsSep ", " actualOutputs}

            and is missing the following outputs:

            ${concatStrings (map (output: "  - ${output}\n") missingOutputs)}
          ''
        ).meta.outputsToInstall or [ ];
      actualOutputs = attrs.outputs or [ "out" ];
      missingOutputs = filter (output: !elem output actualOutputs) expectedOutputs;
    in
    ''
      The package ${getNameWithVersion attrs} has set meta.outputsToInstall to: ${concatStringsSep ", " expectedOutputs}

      however ${getNameWithVersion attrs} only has the outputs: ${concatStringsSep ", " actualOutputs}

      and is missing the following outputs:

      ${concatStrings (map (output: "  - ${output}\n") missingOutputs)}
    '';

  remediate_predicate = predicateConfigAttr: attrs: ''

    Alternatively you can configure a predicate to allow specific packages:
      { nixpkgs.config.${predicateConfigAttr} = pkg: builtins.elem (lib.getName pkg) [
          "${getName attrs}"
        ];
      }
  '';
  remediate_list_or_predicate =
    listAttr: predicateAttr: pkg:
    let
      pkgName = getName pkg;
      # split the blocked package's name into individual words so we can
      # make a good "match against prefix" example in the error message
      attrsWords = lib.splitStringBy (
        prev: curr:
        elem curr [
          "-"
          "_"
          " "
        ]
      ) false pkgName;
    in
    ''

      Alternatively, you can specify a list of individual packages to allow:
        { nixpkgs.config.${listAttr} = [ "${pkgName}" ]; }

      To get more control, you can configure a predicate to allow specific packages:
        { nixpkgs.config.${predicateAttr} = pkg:
            lib.hasPrefix "${lib.head attrsWords}" (lib.getName pkg)
        }

      Note: If both are set, a package will be accepted if it is allowed by at least one of these.
    '';
  remediate_allowlist = allow_attr: rebuild_amendment: ''
    a) To temporarily allow ${remediation_phrase allow_attr}, you can use an environment variable
       for a single invocation of the nix tools.

         $ export ${remediation_env_var allow_attr}=1
         ${flakeNote}
    b) For `nixos-rebuild` you can set
      { nixpkgs.config.allow${allow_attr} = true; }
    in configuration.nix to override this.
    ${rebuild_amendment}
    c) For `nix-env`, `nix-build`, `nix-shell` or any other Nix command you can add
      { allow${allow_attr} = true; }
    to ~/.config/nixpkgs/config.nix.
  '';
  remediate_insecure =
    attrs:
    ''

      Known issues:
    ''
    + (concatStrings (map (issue: " - ${issue}\n") attrs.meta.knownVulnerabilities))
    + ''

      You can install it anyway by allowing this package, using the
      following methods:

      a) To temporarily allow all insecure packages, you can use an environment
         variable for a single invocation of the nix tools:

           $ export NIXPKGS_ALLOW_INSECURE=1
           ${flakeNote}
      b) for `nixos-rebuild` you can add ‘${getNameWithVersion attrs}’ to
         `nixpkgs.config.permittedInsecurePackages` in the configuration.nix,
         like so:

           {
             nixpkgs.config.permittedInsecurePackages = [
               "${getNameWithVersion attrs}"
             ];
           }

      c) For `nix-env`, `nix-build`, `nix-shell` or any other Nix command you can add
         ‘${getNameWithVersion attrs}’ to `permittedInsecurePackages` in
         ~/.config/nixpkgs/config.nix, like so:

           {
             permittedInsecurePackages = [
               "${getNameWithVersion attrs}"
             ];
           }

    '';
}
