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

  /*
  Knot uses a configuration format that looks like YAML and quacks
  like YAML but isn't YAML. In particular:

    - The top level has to be formatted in YAML style, so we can't just
      throw JSON in

    - Keys may be duplicated, in which case the resulting value is a
      list composed of all the values set (which we use here)

    - The parser cares a great deal about the order of keys: for
      instance, when defining an ACL, the `id` attribute must be the
      first. Unfortunately, this is not documented, nor is the error
      message thrown if these conditions aren't fulfilled very
      helpful.

   … so we have an extra format just for knot.

  */
  knotConf = { knot ? pkgs.knot-dns }: rec {
    /*
    The type isn't as strict as it could be: we're trying to strike a
    balance here between how much code we have to write (and keep
    synced with knot's behaviour) and how much checking we can do at
    evaluation time. Either way, knot checks it for complete validity
    at build time (see the definition of generate).

    Top-level objects ("sections") can be either a "settings block"
    (an attrset containing some named options) — like "server" and
    "database" — or a list of settings blocks, like "acl" and "zone".
    We'll just validate that we have settings blocks, but not if the
    names or contents correspond to the blocks known by knot.
    */
    type = with lib.types; let
      jsonType = (json {}).type;
      settingsBlock = (attrsOf jsonType) // { description = "knot.conf(5) settings block"; };
    in (attrsOf (either settingsBlock (listOf settingsBlock))) // {
      description = "knot.conf(5)";
    };

    generateString = settings: with lib; let
      order = [ "domain" "id" "target" ];
      attrNamesOrdered = s: intersectLists (attrNames s) order ++ subtractLists order (attrNames s);
      mkSection = n: v:
        "${n}:" + (
          # Empty section
          if v == [] || v == {} then "\n"
          # One settings block
          else if isAttrs v then "\n  " + mkPairs v
          # Multiple settings blocks
          else if isList v then concatMapStrings (settingsBlock: "\n- " + mkPairs settingsBlock) v
          # No settings blocks!?
          else throw "${generators.toPretty {} v} does not appear to be a valid knot.conf section."
        );
      mkPairs = v: concatStringsSep "\n  " (flatten (map (e: mkPair e v.${e}) (attrNamesOrdered v)));
      mkPair = n: v:
        if isList v then map (mkPair n) v
        else singleton ("${n}: " + (
          if isBool v then boolToString v
          else if strings.isCoercibleToString v then (builtins.toJSON (toString v))
          else throw "unsupported value type ${n}=" + (generators.toPretty {} v)
        ));
    in concatStringsSep "\n" (mapAttrsToList mkSection settings);

    generate = name: value: pkgs.runCommandNoCC name {
      nativeBuildInputs = [ knot ];
      value = generateString value;
      passAsFile = [ "value" ];
    } ''
      knotc --config "$valuePath" conf-export >$out
    '';
  };
}
