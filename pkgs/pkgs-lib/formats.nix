{ lib, pkgs }:
let
  inherit (lib)
    mapAttrs
    optionalAttrs
    warn
    ;

  inherit (lib.types)
    attrsOf
    bool
    coercedTo
    either
    float
    int
    listOf
    luaInline
    mkOptionType
    nonEmptyListOf
    nullOr
    oneOf
    path
    str
    ;

  # Attributes added accidentally in https://github.com/NixOS/nixpkgs/pull/335232 (2024-08-18)
  # Deprecated in https://github.com/NixOS/nixpkgs/pull/415666 (2025-06)
  allowAliases = pkgs.config.allowAliases or false;
  aliasWarning = name: warn "`formats.${name}` is deprecated; use `lib.types.${name}` instead.";
  aliases = mapAttrs aliasWarning {
    inherit
      attrsOf
      bool
      coercedTo
      either
      float
      int
      listOf
      luaInline
      mkOptionType
      nonEmptyListOf
      nullOr
      oneOf
      path
      str
      ;
  };

  json2x = pkgs.buildPackages.callPackage ./formats/json2x/package.nix { };
in
optionalAttrs allowAliases aliases
// rec {

  /*
    Every following entry represents a format for program configuration files
    used for `settings`-style options (see https://github.com/NixOS/rfcs/pull/42).
    Each entry should look as follows:

      <format> = <parameters>: {
        #        ^^ Parameters for controlling the format

        # The module system type most suitable for representing such a format
        # The description needs to be overwritten for recursive types
        type = ...;

        # Utility functions for convenience, or special interactions with the
        # format (optional)
        lib = {
          exampleFunction = ...
          # Types specific to the format (optional)
          types = { ... };
          ...
        };

        # generate :: Name -> Value -> Path
        # A function for generating a file with a value of such a type
        generate = ...;

      });

    Please note that `pkgs` may not always be available for use due to the split
    options doc build introduced in fc614c37c653, so lazy evaluation of only the
    'type' field is required.
  */

  cdn = (import ./formats/cdn/default.nix { inherit lib pkgs; }).format;

  configobj = (import ./formats/configobj/default.nix { inherit lib pkgs; }).format;

  elixirConf = (import ./formats/elixir-conf/default.nix { inherit lib pkgs; }).format;

  gitIni = (import ./formats/git-ini/default.nix { inherit lib pkgs; }).format;

  hcl1 = (import ./formats/hcl1/default.nix { inherit lib pkgs json; }).format;

  hocon = (import ./formats/hocon/default.nix { inherit lib pkgs; }).format;

  ini = (import ./formats/ini/default.nix { inherit lib pkgs; }).format;

  iniWithGlobalSection =
    (import ./formats/ini-with-global-section/default.nix { inherit lib pkgs; }).format;

  javaProperties = (import ./formats/java-properties/default.nix { inherit lib pkgs; }).format;

  json = (import ./formats/json/default.nix { inherit lib pkgs; }).format;

  keyValue = (import ./formats/key-value/default.nix { inherit lib pkgs; }).format;

  libconfig = (import ./formats/libconfig/default.nix { inherit lib pkgs; }).format;

  lua = (import ./formats/lua/default.nix { inherit lib pkgs; }).format;

  nixConf = (import ./formats/nix-conf/default.nix { inherit lib pkgs; }).format;

  php = (import ./formats/php/default.nix { inherit lib pkgs; }).format;

  plist = (import ./formats/plist/default.nix { inherit lib pkgs; }).format;

  pythonVars = (import ./formats/python-vars/default.nix { inherit lib pkgs; }).format;

  systemd = (import ./formats/systemd/default.nix { inherit lib pkgs ini; }).format;

  toml = (import ./formats/toml/default.nix { inherit lib pkgs json2x; }).format;

  xml = (import ./formats/xml/default.nix { inherit lib pkgs; }).format;

  yaml = yaml_1_1;

  yaml_1_1 = (import ./formats/yaml-1-1/default.nix { inherit lib pkgs; }).format;

  yaml_1_2 = (import ./formats/yaml-1-2/default.nix { inherit lib pkgs; }).format;
}
