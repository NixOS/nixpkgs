{
  lib,
  pkgs,
}:
let
  inherit (lib)
    concatStringsSep
    escape
    flatten
    isAttrs
    isFloat
    isInt
    isList
    isString
    mapAttrs
    mapAttrsToList
    mkOptionType
    types
    ;
  inherit (types)
    attrsOf
    bool
    either
    float
    int
    listOf
    nullOr
    oneOf
    str
    ;
in
{
  /*
    For configurations of Elixir project, like config.exs or runtime.exs

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
  format =
    let
      toElixir =
        value:
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
          list value
        else
          abort "formats.elixirConf: should never happen (value = ${value})";

      escapeElixir = escape [
        "\\"
        "#"
        "\""
      ];
      string = value: "\"${escapeElixir value}\"";

      attrs =
        set:
        if set ? _elixirType then
          specialType set
        else
          let
            toKeyword = name: value: "${name}: ${toElixir value}";
            keywordList = concatStringsSep ", " (mapAttrsToList toKeyword set);
          in
          "[" + keywordList + "]";

      listContent = values: concatStringsSep ", " (map toElixir values);

      list = values: "[" + (listContent values) + "]";

      specialType =
        { value, _elixirType }:
        if _elixirType == "raw" then
          value
        else if _elixirType == "atom" then
          value
        else if _elixirType == "map" then
          elixirMap value
        else if _elixirType == "tuple" then
          tuple value
        else if _elixirType == "charlist" then
          charlist value
        else
          abort "formats.elixirConf: should never happen (_elixirType = ${_elixirType})";

      elixirMap =
        set:
        let
          toEntry = name: value: "${toElixir name} => ${toElixir value}";
          entries = concatStringsSep ", " (mapAttrsToList toEntry set);
        in
        "%{${entries}}";

      tuple = values: "{${listContent values}}";

      charlist = value: "~c\"${value}\"";

      toConf =
        let
          keyConfig =
            rootKey: key: value:
            "config ${rootKey}, ${key}, ${toElixir value}";
          keyConfigs = rootKey: values: mapAttrsToList (keyConfig rootKey) values;
        in
        values:
        let
          rootConfigs = flatten (mapAttrsToList keyConfigs values);
        in
        ''
          import Config

          ${concatStringsSep "\n" rootConfigs}
        '';
    in
    {
      elixir ? pkgs.elixir,
    }:
    {
      type =
        let
          valueType =
            nullOr (oneOf [
              bool
              int
              float
              str
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "Elixir value";
            };
        in
        attrsOf (attrsOf valueType);

      lib =
        let
          mkRaw = value: {
            inherit value;
            _elixirType = "raw";
          };

        in
        {
          inherit mkRaw;

          # Fetch an environment variable at runtime, with optional fallback
          mkGetEnv =
            {
              envVariable,
              fallback ? null,
            }:
            mkRaw "System.get_env(${toElixir envVariable}, ${toElixir fallback})";

          /*
            Make an Elixir atom.

            Note: lowercase atoms still need to be prefixed by ':'
          */
          mkAtom = value: {
            inherit value;
            _elixirType = "atom";
          };

          # Make an Elixir charlist out of a string.
          mkCharlist = value: {
            inherit value;
            _elixirType = "charlist";
          };

          # Make an Elixir tuple out of a list.
          mkTuple = value: {
            inherit value;
            _elixirType = "tuple";
          };

          # Make an Elixir map out of an attribute set.
          mkMap = value: {
            inherit value;
            _elixirType = "map";
          };

          /*
            Contains Elixir types. Every type it exports can also be replaced
            by raw Elixir code (i.e. every type is `either type rawElixir`).

            It also reexports standard types, wrapping them so that they can
            also be raw Elixir.
          */
          types =
            let
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

              charlist = elixirOr (mkOptionType {
                name = "elixirCharlist";
                description = "elixir charlist";
                check = isElixirType "charlist";
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
            }
            // mapAttrs (_name: type: elixirOr type) types;
        };

      generate =
        name: value:
        pkgs.runCommand name
          {
            value = toConf value;
            nativeBuildInputs = [ elixir ];
            preferLocalBuild = true;
            __structuredAttrs = true;
          }
          ''
            printf "%s" "$value" > "$out"
            mix format "$out"
          '';
    };
}
