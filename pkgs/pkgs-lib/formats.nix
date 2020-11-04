{ lib, pkgs }:
rec {

  /*

  Every following entry represents a format for program configuration files
  used for `settings`-style options (see https://github.com/NixOS/rfcs/pull/42).
  Each entry should look as follows:

    <format> = <parameters>: {
      #        ^^ Parameters for controlling the format

      # The module system type most suitable for representing such a format
      # The description needs to be overwritten for recursive types
      type = ...;

      # generate :: Name -> Value -> Path
      # A function for generating a file with a value of such a type
      generate = ...;

    });
  */


  json = {}: {

    type = with lib.types; let
      valueType = nullOr (oneOf [
        bool
        int
        float
        str
        (attrsOf valueType)
        (listOf valueType)
      ]) // {
        description = "JSON value";
      };
    in valueType;

    generate = name: value: pkgs.runCommandNoCC name {
      nativeBuildInputs = [ pkgs.jq ];
      value = builtins.toJSON value;
      passAsFile = [ "value" ];
    } ''
      jq . "$valuePath"> $out
    '';

  };

  # YAML has been a strict superset of JSON since 1.2
  yaml = {}:
    let jsonSet = json {};
    in jsonSet // {
      type = jsonSet.type // {
        description = "YAML value";
      };
    };

  ini = { listsAsDuplicateKeys ? false, ... }@args: {

    type = with lib.types; let

      singleIniAtom = nullOr (oneOf [
        bool
        int
        float
        str
      ]) // {
        description = "INI atom (null, bool, int, float or string)";
      };

      iniAtom =
        if listsAsDuplicateKeys then
          coercedTo singleIniAtom lib.singleton (listOf singleIniAtom) // {
            description = singleIniAtom.description + " or a list of them for duplicate keys";
          }
        else
          singleIniAtom;

    in attrsOf (attrsOf iniAtom);

    generate = name: value: pkgs.writeText name (lib.generators.toINI args value);

  };

  toml = {}: json {} // {
    type = with lib.types; let
      valueType = oneOf [
        bool
        int
        float
        str
        (attrsOf valueType)
        (listOf valueType)
      ] // {
        description = "TOML value";
      };
    in valueType;

    generate = name: value: pkgs.runCommandNoCC name {
      nativeBuildInputs = [ pkgs.remarshal ];
      value = builtins.toJSON value;
      passAsFile = [ "value" ];
    } ''
      json2toml "$valuePath" "$out"
    '';

  };
}
