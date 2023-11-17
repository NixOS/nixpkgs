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


  inherit (import ./formats/java-properties/default.nix { inherit lib pkgs; })
    javaProperties;

  libconfig = (import ./formats/libconfig/default.nix { inherit lib pkgs; }).format;

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

    generate = name: value: pkgs.callPackage ({ runCommand, jq }: runCommand name {
      nativeBuildInputs = [ jq ];
      value = builtins.toJSON value;
      passAsFile = [ "value" ];
    } ''
      jq . "$valuePath"> $out
    '') {};

  };

  yaml = {}: {

    generate = name: value: pkgs.callPackage ({ runCommand, remarshal }: runCommand name {
      nativeBuildInputs = [ remarshal ];
      value = builtins.toJSON value;
      passAsFile = [ "value" ];
    } ''
      json2yaml "$valuePath" "$out"
    '') {};

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

  keyValue = {
    # Represents lists as duplicate keys
    listsAsDuplicateKeys ? false,
    # Alternative to listsAsDuplicateKeys, converts list to non-list
    # listToValue :: [Atom] -> Atom
    listToValue ? null,
    ...
    }@args:
    assert !listsAsDuplicateKeys || listToValue == null;
    {

    type = with lib.types; let

      singleAtom = nullOr (oneOf [
        bool
        int
        float
        str
      ]) // {
        description = "atom (null, bool, int, float or string)";
      };

      atom =
        if listsAsDuplicateKeys then
          coercedTo singleAtom lib.singleton (listOf singleAtom) // {
            description = singleAtom.description + " or a list of them for duplicate keys";
          }
        else if listToValue != null then
          coercedTo singleAtom lib.singleton (nonEmptyListOf singleAtom) // {
            description = singleAtom.description + " or a non-empty list of them";
          }
        else
          singleAtom;

    in attrsOf atom;

    generate = name: value:
      let
        transformedValue =
          if listToValue != null
          then
            lib.mapAttrs (key: val:
              if lib.isList val then listToValue val else val
            ) value
          else value;
      in pkgs.writeText name (lib.generators.toKeyValue (removeAttrs args ["listToValue"]) transformedValue);

  };

  gitIni = { listsAsDuplicateKeys ? false, ... }@args: {

    type = with lib.types; let

      iniAtom = (ini args).type/*attrsOf*/.functor.wrapped/*attrsOf*/.functor.wrapped;

    in attrsOf (attrsOf (either iniAtom (attrsOf iniAtom)));

    generate = name: value: pkgs.writeText name (lib.generators.toGitINI value);
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

    generate = name: value: pkgs.callPackage ({ runCommand, remarshal }: runCommand name {
      nativeBuildInputs = [ remarshal ];
      value = builtins.toJSON value;
      passAsFile = [ "value" ];
    } ''
      json2toml "$valuePath" "$out"
    '') {};

  };

  /* For configurations of Elixir project, like config.exs or runtime.exs

    Most Elixir project are configured using the [Config] Elixir DSL

    Since Elixir has more types than Nix, we need a way to map Nix types to
    more than 1 Elixir type. To that end, this format provides its own library,
    and its own set of types.

    To be more detailed, a Nix attribute set could correspond in Elixir to a
    [Keyword list] (the more common type), or it could correspond to a [Map].

    A Nix string could correspond in Elixir to a [String] (also called
    "binary"), an [Atom], or a list of chars (usually discouraged).

    A Nix array could correspond in Elixir to a [List] or a [Tuple].

    Some more types exists, like records, regexes, but since they are less used,
    we can leave the `mkRaw` function as an escape hatch.

    For more information on how to use this format in modules, please refer to
    the Elixir section of the Nixos documentation.

    TODO: special Elixir values doesn't show up nicely in the documentation

    [Config]: <https://hexdocs.pm/elixir/Config.html>
    [Keyword list]: <https://hexdocs.pm/elixir/Keyword.html>
    [Map]: <https://hexdocs.pm/elixir/Map.html>
    [String]: <https://hexdocs.pm/elixir/String.html>
    [Atom]: <https://hexdocs.pm/elixir/Atom.html>
    [List]: <https://hexdocs.pm/elixir/List.html>
    [Tuple]: <https://hexdocs.pm/elixir/Tuple.html>
  */
  elixirConf = { elixir ? pkgs.elixir }:
    with lib; let
      toElixir = value: with builtins;
        if value == null then "nil" else
        if value == true then "true" else
        if value == false then "false" else
        if isInt value || isFloat value then toString value else
        if isString value then string value else
        if isAttrs value then attrs value else
        if isList value then list value else
        abort "formats.elixirConf: should never happen (value = ${value})";

      escapeElixir = escape [ "\\" "#" "\"" ];
      string = value: "\"${escapeElixir value}\"";

      attrs = set:
        if set ? _elixirType then specialType set
        else
          let
            toKeyword = name: value: "${name}: ${toElixir value}";
            keywordList = concatStringsSep ", " (mapAttrsToList toKeyword set);
          in
          "[" + keywordList + "]";

      listContent = values: concatStringsSep ", " (map toElixir values);

      list = values: "[" + (listContent values) + "]";

      specialType = { value, _elixirType }:
        if _elixirType == "raw" then value else
        if _elixirType == "atom" then value else
        if _elixirType == "map" then elixirMap value else
        if _elixirType == "tuple" then tuple value else
        abort "formats.elixirConf: should never happen (_elixirType = ${_elixirType})";

      elixirMap = set:
        let
          toEntry = name: value: "${toElixir name} => ${toElixir value}";
          entries = concatStringsSep ", " (mapAttrsToList toEntry set);
        in
        "%{${entries}}";

      tuple = values: "{${listContent values}}";

      toConf = values:
        let
          keyConfig = rootKey: key: value:
            "config ${rootKey}, ${key}, ${toElixir value}";
          keyConfigs = rootKey: values: mapAttrsToList (keyConfig rootKey) values;
          rootConfigs = flatten (mapAttrsToList keyConfigs values);
        in
        ''
          import Config

          ${concatStringsSep "\n" rootConfigs}
        '';
    in
    {
      type = with lib.types; let
        valueType = nullOr
          (oneOf [
            bool
            int
            float
            str
            (attrsOf valueType)
            (listOf valueType)
          ]) // {
          description = "Elixir value";
        };
      in
      attrsOf (attrsOf (valueType));

      lib =
        let
          mkRaw = value: {
            inherit value;
            _elixirType = "raw";
          };

        in
        {
          inherit mkRaw;

          /* Fetch an environment variable at runtime, with optional fallback
          */
          mkGetEnv = { envVariable, fallback ? null }:
            mkRaw "System.get_env(${toElixir envVariable}, ${toElixir fallback})";

          /* Make an Elixir atom.

            Note: lowercase atoms still need to be prefixed by ':'
          */
          mkAtom = value: {
            inherit value;
            _elixirType = "atom";
          };

          /* Make an Elixir tuple out of a list.
          */
          mkTuple = value: {
            inherit value;
            _elixirType = "tuple";
          };

          /* Make an Elixir map out of an attribute set.
          */
          mkMap = value: {
            inherit value;
            _elixirType = "map";
          };

          /* Contains Elixir types. Every type it exports can also be replaced
             by raw Elixir code (i.e. every type is `either type rawElixir`).

             It also reexports standard types, wrapping them so that they can
             also be raw Elixir.
          */
          types = with lib.types; let
            isElixirType = type: x: (x._elixirType or "") == type;

            rawElixir = mkOptionType {
              name = "rawElixir";
              description = "raw elixir";
              check = isElixirType "raw";
            };

            elixirOr = other: either other rawElixir;
          in
          {
            inherit rawElixir elixirOr;

            atom = elixirOr (mkOptionType {
              name = "elixirAtom";
              description = "elixir atom";
              check = isElixirType "atom";
            });

            tuple = elixirOr (mkOptionType {
              name = "elixirTuple";
              description = "elixir tuple";
              check = isElixirType "tuple";
            });

            map = elixirOr (mkOptionType {
              name = "elixirMap";
              description = "elixir map";
              check = isElixirType "map";
            });
            # Wrap standard types, since anything in the Elixir configuration
            # can be raw Elixir
          } // lib.mapAttrs (_name: type: elixirOr type) lib.types;
        };

      generate = name: value: pkgs.runCommand name
        {
          value = toConf value;
          passAsFile = [ "value" ];
          nativeBuildInputs = [ elixir ];
        } ''
        cp "$valuePath" "$out"
        mix format "$out"
      '';
    };

  # Outputs a succession of Python variable assignments
  # Useful for many Django-based services
  pythonVars = {}: {
    type = with lib.types; let
      valueType = nullOr(oneOf [
        bool
        float
        int
        path
        str
        (attrsOf valueType)
        (listOf valueType)
      ]) // {
        description = "Python value";
      };
    in attrsOf valueType;
    generate = name: value: pkgs.callPackage ({ runCommand, python3, black }: runCommand name {
      nativeBuildInputs = [ python3 black ];
      value = builtins.toJSON value;
      pythonGen = ''
        import json
        import os

        with open(os.environ["valuePath"], "r") as f:
            for key, value in json.load(f).items():
                print(f"{key} = {repr(value)}")
      '';
      passAsFile = [ "value" "pythonGen" ];
    } ''
      cat "$valuePath"
      python3 "$pythonGenPath" > $out
      black $out
    '') {};
  };

}
