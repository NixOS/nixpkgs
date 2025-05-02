{
  lib,
  pkgs,
  ...
}:
/*
   For configurations using [EDN].

  Since EDN has more types than Nix, we need a way to map Nix types to
  more than 1 EDN type. To that end, this format provides its own library,
  and its own set of types.

  A Nix string could correspond in EDN to a [String], a [Symbol] or a [Keyword].

  A Nix array could correspond in EDN to a [List],[Set] or a [Vector].

  Some more types exists, like fractions or regexes, but since they are less used,
  we can leave the `mkRaw` function as an escape hatch.

  [EDN]: <https://github.com/edn-format/edn>
  [String]: <https://github.com/edn-format/edn#strings>
  [Symbol]: <https://github.com/edn-format/edn#symbols>
  [Keyword]: <https://github.com/edn-format/edn#keywords>
  [List]: <https://github.com/edn-format/edn#lists>
  [Set]: <https://github.com/edn-format/edn#sets>
  [Vector]: <https://github.com/edn-format/edn#vectors>
*/
with lib;
{
  keywordTransform ? (kw: "${lib.optionalString (!lib.hasPrefix ":" kw) ":"}${kw}"),
  formatter ? "${pkgs.zprint}/bin/zprint",
}:
let
  toEdn =
    value:
    with builtins;
    if value == null then
      "nil"
    else if value == true then
      "true"
    else if value == false then
      "false"
    else if isInt value || isFloat value then
      toString value
    else if isString value then
      string value
    else if isAttrs value then
      attrs value
    else if isList value then
      vector value
    else
      abort "formats.edn: should never happen (value = ${value})";

  escapeEdn = escape [
    "\\"
    "#"
    "\""
  ];
  string = value: "\"${escapeEdn value}\"";

  attrs =
    set:
    if set ? _ednType then
      specialType set
    else
      let
        toKVPair = name: value: "${keywordTransform name} ${toEdn value}";
      in
      "{" + concatStringsSep ", " (mapAttrsToList toKVPair set) + "}";

  kv =
    {
      key,
      value,
      ...
    }:
    "${toEdn key} ${toEdn value}";

  ednMap = kvs: "{" + concatStringsSep ", " (map kv kvs) + "}";

  listContent = values: concatStringsSep ", " (map toEdn values);

  vector = values: "[" + (listContent values) + "]";

  list = values: "(" + (listContent values) + ")";

  set = values: "#{" + (listContent values) + "}";

  keyword = value: ":${value}";

  symbol = value: "${value}";

  taggedElement =
    {
      tag,
      value,
    }:
    "#${tag} ${toEdn value}";

  specialType =
    {
      value,
      _ednType,
    }@st:
    if _ednType == "raw" then
      value
    else if _ednType == "list" then
      list value
    else if _ednType == "set" then
      set value
    else if _ednType == "keyword" then
      keyword value
    else if _ednType == "symbol" then
      symbol value
    else if _ednType == "taggedElement" then
      taggedElement st
    else if _ednType == "map" then
      ednMap value
    else
      abort "formats.edn: should never happen (_ednType = ${_ednType})";
in
{
  type =
    with lib.types;
    let
      valueType =
        nullOr (oneOf [
          bool
          int
          float
          str
          path
          (attrsOf valueType)
          (listOf valueType)
        ])
        // {
          description = "EDN value";
        };
    in
    valueType;

  lib =
    let
      mkRaw = value: {
        inherit value;
        _ednType = "raw";
      };
    in
    {
      inherit mkRaw;

      # Make an Edn set out of a list.
      mkSet = value: {
        inherit value;
        _ednType = "set";
      };

      # Make an Edn list out of a list.
      mkList = value: {
        inherit value;
        _ednType = "list";
      };

      # Make an Edn keyword out of a string.
      mkKeyword = value: {
        inherit value;
        _ednType = "keyword";
      };

      # Make an Edn symbol out of a string.
      mkSymbol = value: {
        inherit value;
        _ednType = "symbol";
      };

      # Make an Edn tagged element.
      mkTaggedElement = tag: value: {
        inherit tag value;
        _ednType = "taggedElement";
      };

      # Make an Edn map out of a list of pairs. This is needed for maps with keys that are not keywords.
      mkMap = value: {
        inherit value;
        _ednType = "map";
      };

      /*
        Make an Edn MapEntry for use with mkMap out of a key and a value
        This is needed for keys that are not keywords
      */
      mkKV = key: value: {
        inherit key value;
        _ednType = "kv";
      };

      /*
        Contains Edn types. Every type it exports can also be replaced
        by raw Edn code (i.e. every type is `either type rawEdn`).

        It also reexports standard types, wrapping them so that they can
        also be raw Edn.
      */
      types =
        with lib.types;
        let
          isEdnType = type: x: (x._ednType or "") == type;

          rawEdn = mkOptionType {
            name = "rawEdn";
            description = "raw edn";
            check = isEdnType "raw";
          };

          ednOr = other: either other rawEdn;
        in
        {
          inherit rawEdn ednOr;

          list = ednOr (mkOptionType {
            name = "ednList";
            description = "edn list";
            check = isEdnType "list";
          });

          set = ednOr (mkOptionType {
            name = "ednSet";
            description = "edn set";
            check = isEdnType "set";
          });

          keyword = ednOr (mkOptionType {
            name = "ednKeyword";
            description = "edn keyword";
            check = isEdnType "keyword";
          });

          symbol = ednOr (mkOptionType {
            name = "ednSymbol";
            description = "edn symbol";
            check = isEdnType "symbol";
          });

          taggedElement = ednOr (mkOptionType {
            name = "ednTaggedElement";
            description = "edn taggedElement";
            check = isEdnType "taggedElement";
          });

          map = ednOr (mkOptionType {
            name = "ednMap";
            description = "edn map";
            check = m: (isEdnType "map" m) && (all (isEdnType "kv") m.kvs);
          });
          # Wrap standard types, since anything in the Edn configuration
          # can be raw Edn
        }
        // lib.mapAttrs (_name: type: ednOr type) lib.types;
    };

  generate =
    name: value:
    let
      edn = toEdn value;
    in
    runCommand name
      {
        inherit name edn;
        passAsFile = [ "edn" ];
      }
      ''
        cat "$ednPath" | ${formatter} > "$out"
      '';
}
