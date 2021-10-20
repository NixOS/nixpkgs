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
        path
        (attrsOf valueType)
        (listOf valueType)
      ]) // {
        description = "JSON value";
      };
    in valueType;

    generate = name: value: pkgs.runCommand name {
      nativeBuildInputs = [ pkgs.jq ];
      value = builtins.toJSON value;
      passAsFile = [ "value" ];
    } ''
      jq . "$valuePath"> $out
    '';

  };

  yaml = {}: {

    generate = name: value: pkgs.runCommand name {
        nativeBuildInputs = [ pkgs.remarshal ];
        value = builtins.toJSON value;
        passAsFile = [ "value" ];
      } ''
        json2yaml "$valuePath" "$out"
      '';

    type = with lib.types; let
      valueType = nullOr (oneOf [
        bool
        int
        float
        str
        path
        (attrsOf valueType)
        (listOf valueType)
      ]) // {
        description = "YAML value";
      };
    in valueType;

  };

  ini = {
    # Represents lists as duplicate keys
    listsAsDuplicateKeys ? false,
    # Alternative to listsAsDuplicateKeys, converts list to non-list
    # listToValue :: [IniAtom] -> IniAtom
    listToValue ? null,
    ...
    }@args:
    assert !listsAsDuplicateKeys || listToValue == null;
    {

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
        else if listToValue != null then
          coercedTo singleIniAtom lib.singleton (nonEmptyListOf singleIniAtom) // {
            description = singleIniAtom.description + " or a non-empty list of them";
          }
        else
          singleIniAtom;

    in attrsOf (attrsOf iniAtom);

    generate = name: value:
      let
        transformedValue =
          if listToValue != null
          then
            lib.mapAttrs (section: lib.mapAttrs (key: val:
              if lib.isList val then listToValue val else val
            )) value
          else value;
      in pkgs.writeText name (lib.generators.toINI (removeAttrs args ["listToValue"]) transformedValue);

  };

  toml = {}: json {} // {
    type = with lib.types; let
      valueType = oneOf [
        bool
        int
        float
        str
        path
        (attrsOf valueType)
        (listOf valueType)
      ] // {
        description = "TOML value";
      };
    in valueType;

    generate = name: value: pkgs.runCommand name {
      nativeBuildInputs = [ pkgs.remarshal ];
      value = builtins.toJSON value;
      passAsFile = [ "value" ];
    } ''
      json2toml "$valuePath" "$out"
    '';

  };
}
