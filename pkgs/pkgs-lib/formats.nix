{ lib, pkgs }:
let
  inherit (lib)
    boolToString
    concatStringsSep
    escape
    filterAttrs
    flatten
    hasPrefix
    id
    isAttrs
    isBool
    isDerivation
    isFloat
    isInt
    isList
    isString
    mapAttrs
    mapAttrsToList
    mkOption
    optionalAttrs
    optionalString
    pipe
    singleton
    strings
    toPretty
    types
    versionAtLeast
    warn
    ;

  inherit (lib.generators)
    mkValueStringDefault
    toGitINI
    toINI
    toINIWithGlobalSection
    toKeyValue
    toLua
    mkLuaInline
    ;

  inherit (lib.types)
    attrsOf
    atom
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
    submodule
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

  inherit (import ./formats/java-properties/default.nix { inherit lib pkgs; })
    javaProperties
    ;

  libconfig = (import ./formats/libconfig/default.nix { inherit lib pkgs; }).format;

  hocon = (import ./formats/hocon/default.nix { inherit lib pkgs; }).format;

  php = (import ./formats/php/default.nix { inherit lib pkgs; }).format;

  json =
    { }:
    {

      type =
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
              description = "JSON value";
            };
        in
        valueType;

      generate =
        name: value:
        pkgs.callPackage (
          { runCommand, jq }:
          runCommand name
            {
              nativeBuildInputs = [ jq ];
              value = builtins.toJSON value;
              passAsFile = [ "value" ];
              preferLocalBuild = true;
            }
            ''
              jq . "$valuePath"> $out
            ''
        ) { };

    };

  yaml = yaml_1_1;

  yaml_1_1 =
    { }:
    {
      generate =
        name: value:
        pkgs.callPackage (
          { runCommand, remarshal_0_17 }:
          runCommand name
            {
              nativeBuildInputs = [ remarshal_0_17 ];
              value = builtins.toJSON value;
              passAsFile = [ "value" ];
              preferLocalBuild = true;
            }
            ''
              json2yaml "$valuePath" "$out"
            ''
        ) { };

      type =
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
              description = "YAML 1.1 value";
            };
        in
        valueType;

    };

  yaml_1_2 =
    { }:
    {
      generate =
        name: value:
        pkgs.callPackage (
          { runCommand, remarshal }:
          runCommand name
            {
              nativeBuildInputs = [ remarshal ];
              value = builtins.toJSON value;
              passAsFile = [ "value" ];
              preferLocalBuild = true;
            }
            ''
              json2yaml "$valuePath" "$out"
            ''
        ) { };

      type =
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
              description = "YAML 1.2 value";
            };
        in
        valueType;

    };

  # the ini formats share a lot of code
  inherit
    (
      let
        singleIniAtom =
          nullOr (oneOf [
            bool
            int
            float
            str
          ])
          // {
            description = "INI atom (null, bool, int, float or string)";
          };
        iniAtom =
          {
            listsAsDuplicateKeys,
            listToValue,
            atomsCoercedToLists,
          }:
          let
            singleIniAtomOr =
              if atomsCoercedToLists then coercedTo singleIniAtom singleton else either singleIniAtom;
          in
          if listsAsDuplicateKeys then
            singleIniAtomOr (listOf singleIniAtom)
            // {
              description = singleIniAtom.description + " or a list of them for duplicate keys";
            }
          else if listToValue != null then
            singleIniAtomOr (nonEmptyListOf singleIniAtom)
            // {
              description = singleIniAtom.description + " or a non-empty list of them";
            }
          else
            singleIniAtom;
        iniSection =
          atom:
          attrsOf atom
          // {
            description = "section of an INI file (attrs of " + atom.description + ")";
          };

        maybeToList =
          listToValue:
          if listToValue != null then
            mapAttrs (key: val: if isList val then listToValue val else val)
          else
            id;
      in
      {
        ini =
          {
            # Represents lists as duplicate keys
            listsAsDuplicateKeys ? false,
            # Alternative to listsAsDuplicateKeys, converts list to non-list
            # listToValue :: [IniAtom] -> IniAtom
            listToValue ? null,
            # Merge multiple instances of the same key into a list
            atomsCoercedToLists ? null,
            ...
          }@args:
          assert listsAsDuplicateKeys -> listToValue == null;
          assert atomsCoercedToLists != null -> (listsAsDuplicateKeys || listToValue != null);
          let
            atomsCoercedToLists' = if atomsCoercedToLists == null then false else atomsCoercedToLists;
            atom = iniAtom {
              inherit listsAsDuplicateKeys listToValue;
              atomsCoercedToLists = atomsCoercedToLists';
            };
          in
          {

            type = attrsOf (iniSection atom);
            lib.types.atom = atom;

            generate =
              name: value:
              pipe value [
                (mapAttrs (_: maybeToList listToValue))
                (toINI (
                  removeAttrs args [
                    "listToValue"
                    "atomsCoercedToLists"
                  ]
                ))
                (pkgs.writeText name)
              ];
          };

        iniWithGlobalSection =
          {
            # Represents lists as duplicate keys
            listsAsDuplicateKeys ? false,
            # Alternative to listsAsDuplicateKeys, converts list to non-list
            # listToValue :: [IniAtom] -> IniAtom
            listToValue ? null,
            # Merge multiple instances of the same key into a list
            atomsCoercedToLists ? null,
            ...
          }@args:
          assert listsAsDuplicateKeys -> listToValue == null;
          assert atomsCoercedToLists != null -> (listsAsDuplicateKeys || listToValue != null);
          let
            atomsCoercedToLists' = if atomsCoercedToLists == null then false else atomsCoercedToLists;
            atom = iniAtom {
              inherit listsAsDuplicateKeys listToValue;
              atomsCoercedToLists = atomsCoercedToLists';
            };
          in
          {
            type = submodule {
              options = {
                sections = mkOption rec {
                  type = attrsOf (iniSection atom);
                  default = { };
                  description = type.description;
                };
                globalSection = mkOption rec {
                  type = iniSection atom;
                  default = { };
                  description = "global " + type.description;
                };
              };
            };
            lib.types.atom = atom;
            generate =
              name:
              {
                sections ? { },
                globalSection ? { },
                ...
              }:
              pkgs.writeText name (
                toINIWithGlobalSection
                  (removeAttrs args [
                    "listToValue"
                    "atomsCoercedToLists"
                  ])
                  {
                    globalSection = maybeToList listToValue globalSection;
                    sections = mapAttrs (_: maybeToList listToValue) sections;
                  }
              );
          };

        gitIni =
          {
            listsAsDuplicateKeys ? false,
            ...
          }@args:
          let
            atom = iniAtom {
              inherit listsAsDuplicateKeys;
              listToValue = null;
              atomsCoercedToLists = false;
            };
          in
          {
            type = attrsOf (attrsOf (either atom (attrsOf atom)));
            lib.types.atom = atom;
            generate = name: value: pkgs.writeText name (toGitINI value);
          };

      }
    )
    ini
    iniWithGlobalSection
    gitIni
    ;

  # As defined by systemd.syntax(7)
  #
  # null does not set any value, which allows for RFC42 modules to specify
  # optional config options.
  systemd =
    let
      mkValueString = mkValueStringDefault { };
      mkKeyValue = k: v: if v == null then "# ${k} is unset" else "${k} = ${mkValueString v}";

      rawFormat = ini {
        listsAsDuplicateKeys = true;
        inherit mkKeyValue;
      };
    in
    rawFormat
    // {
      generate =
        name: value:
        lib.warn
          "Direct use of `pkgs.formats.systemd` has been deprecated, please use `pkgs.formats.systemd { }` instead."
          rawFormat.generate
          name
          value;
      __functor = self: { }: rawFormat;
    };

  keyValue =
    {
      # Represents lists as duplicate keys
      listsAsDuplicateKeys ? false,
      # Alternative to listsAsDuplicateKeys, converts list to non-list
      # listToValue :: [Atom] -> Atom
      listToValue ? null,
      ...
    }@args:
    assert listsAsDuplicateKeys -> listToValue == null;
    {

      type =
        let

          singleAtom =
            nullOr (oneOf [
              bool
              int
              float
              str
            ])
            // {
              description = "atom (null, bool, int, float or string)";
            };

          atom =
            if listsAsDuplicateKeys then
              coercedTo singleAtom singleton (listOf singleAtom)
              // {
                description = singleAtom.description + " or a list of them for duplicate keys";
              }
            else if listToValue != null then
              coercedTo singleAtom singleton (nonEmptyListOf singleAtom)
              // {
                description = singleAtom.description + " or a non-empty list of them";
              }
            else
              singleAtom;

        in
        attrsOf atom;

      generate =
        name: value:
        let
          transformedValue =
            if listToValue != null then
              mapAttrs (key: val: if isList val then listToValue val else val) value
            else
              value;
        in
        pkgs.writeText name (toKeyValue (removeAttrs args [ "listToValue" ]) transformedValue);

    };

  toml =
    { }:
    json { }
    // {
      type =
        let
          valueType =
            oneOf [
              bool
              int
              float
              str
              path
              (attrsOf valueType)
              (listOf valueType)
            ]
            // {
              description = "TOML value";
            };
        in
        valueType;

      generate =
        name: value:
        pkgs.callPackage (
          { runCommand, remarshal }:
          runCommand name
            {
              nativeBuildInputs = [ remarshal ];
              value = builtins.toJSON value;
              passAsFile = [ "value" ];
              preferLocalBuild = true;
            }
            ''
              json2toml "$valuePath" "$out"
            ''
        ) { };

    };

  /*
    dzikoysk's CDN format, see https://github.com/dzikoysk/cdn

    The result is almost identical to YAML when there are no nested properties,
    but differs enough in the other case to warrant a separate format.
    (see https://github.com/dzikoysk/cdn#supported-formats)

    Currently used by Panda, Reposilite, and FunnyGuilds (as per the repo's readme).
  */
  cdn =
    { }:
    json { }
    // {
      type =
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
              description = "CDN value";
            };
        in
        valueType;

      generate =
        name: value:
        pkgs.callPackage (
          { runCommand, json2cdn }:
          runCommand name
            {
              nativeBuildInputs = [ json2cdn ];
              value = builtins.toJSON value;
              passAsFile = [ "value" ];
              preferLocalBuild = true;
            }
            ''
              json2cdn "$valuePath" > $out
            ''
        ) { };
    };

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
  elixirConf =
    {
      elixir ? pkgs.elixir,
    }:
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

      toConf =
        values:
        let
          keyConfig =
            rootKey: key: value:
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
            passAsFile = [ "value" ];
            nativeBuildInputs = [ elixir ];
            preferLocalBuild = true;
          }
          ''
            cp "$valuePath" "$out"
            mix format "$out"
          '';
    };

  lua =
    {
      asBindings ? false,
      multiline ? true,
      columnWidth ? 100,
      indentWidth ? 2,
      indentUsingTabs ? false,
    }:
    {
      type =
        let
          valueType =
            nullOr (oneOf [
              bool
              float
              int
              path
              str
              luaInline
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "lua value";
              descriptionClass = "noun";
            };
        in
        if asBindings then attrsOf valueType else valueType;
      generate =
        name: value:
        pkgs.callPackage (
          { runCommand, stylua }:
          runCommand name
            {
              nativeBuildInputs = [ stylua ];
              inherit columnWidth;
              inherit indentWidth;
              indentType = if indentUsingTabs then "Tabs" else "Spaces";
              value = toLua { inherit asBindings multiline; } value;
              passAsFile = [ "value" ];
              preferLocalBuild = true;
            }
            ''
              ${optionalString (!asBindings) ''
                echo -n 'return ' >> $out
              ''}
              cat $valuePath >> $out
              stylua \
                --no-editorconfig \
                --line-endings Unix \
                --column-width $columnWidth \
                --indent-width $indentWidth \
                --indent-type $indentType \
                $out
            ''
        ) { };
      # Alias for mkLuaInline
      lib.mkRaw = lib.mkLuaInline;
    };

  nixConf =
    {
      package,
      version,
      extraOptions ? "",
      checkAllErrors ? true,
      checkConfig ? true,
    }:
    let
      isNixAtLeast = versionAtLeast version;
    in
    assert isNixAtLeast "2.2";
    {
      type =
        let
          atomType = nullOr (oneOf [
            bool
            int
            float
            str
            path
            package
          ]);
        in
        attrsOf atomType;
      generate =
        name: value:
        let

          # note that list type has been omitted here as the separator varies, see `nix.settings.*`
          mkValueString =
            v:
            if v == null then
              ""
            else if isInt v then
              toString v
            else if isBool v then
              boolToString v
            else if isFloat v then
              strings.floatToString v
            else if isDerivation v then
              toString v
            else if builtins.isPath v then
              toString v
            else if isString v then
              v
            else if strings.isConvertibleWithToString v then
              toString v
            else
              abort "The nix conf value: ${toPretty { } v} can not be encoded";

          mkKeyValue = k: v: "${escape [ "=" ] k} = ${mkValueString v}";

          mkKeyValuePairs = attrs: concatStringsSep "\n" (mapAttrsToList mkKeyValue attrs);

          isExtra = key: hasPrefix "extra-" key;

        in
        pkgs.writeTextFile {
          inherit name;
          # workaround for https://github.com/NixOS/nix/issues/9487
          # extra-* settings must come after their non-extra counterpart
          text = ''
            # WARNING: this file is generated from the nix.* options in
            # your NixOS configuration, typically
            # /etc/nixos/configuration.nix.  Do not edit it!
            ${mkKeyValuePairs (filterAttrs (key: _: !(isExtra key)) value)}
            ${mkKeyValuePairs (filterAttrs (key: _: isExtra key) value)}
            ${extraOptions}
          '';
          checkPhase = lib.optionalString checkConfig (
            if pkgs.stdenv.hostPlatform != pkgs.stdenv.buildPlatform then
              ''
                echo "Ignoring validation for cross-compilation"
              ''
            else
              let
                showCommand = if isNixAtLeast "2.20pre" then "config show" else "show-config";
              in
              ''
                echo "Validating generated nix.conf"
                ln -s $out ./nix.conf
                set -e
                set +o pipefail
                NIX_CONF_DIR=$PWD \
                  ${package}/bin/nix ${showCommand} ${optionalString (isNixAtLeast "2.3pre") "--no-net"} \
                    ${optionalString (isNixAtLeast "2.4pre") "--option experimental-features nix-command"} \
                  |& sed -e 's/^warning:/error:/' \
                  | (! grep '${if checkAllErrors then "^error:" else "^error: unknown setting"}')
                set -o pipefail
              ''
          );
        };
    };

  # Outputs a succession of Python variable assignments
  # Useful for many Django-based services
  pythonVars =
    { }:
    {
      type =
        let
          valueType =
            nullOr (oneOf [
              bool
              float
              int
              path
              str
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "Python value";
            };
        in
        attrsOf valueType;

      lib = {
        mkRaw = value: {
          inherit value;
          _type = "raw";
        };
      };

      generate =
        name: value:
        pkgs.callPackage (
          {
            runCommand,
            python3,
            black,
          }:
          runCommand name
            {
              nativeBuildInputs = [
                python3
                black
              ];
              imports = builtins.toJSON (value._imports or [ ]);
              value = builtins.toJSON (removeAttrs value [ "_imports" ]);
              pythonGen = ''
                import json
                import os

                def recursive_repr(value: any) -> str:
                    if type(value) is list:
                        return '\n'.join([
                            "[",
                            *[recursive_repr(x) + "," for x in value],
                            "]",
                        ])
                    elif type(value) is dict and value.get("_type") == "raw":
                        return value.get("value")
                    elif type(value) is dict:
                        return '\n'.join([
                            "{",
                            *[f"'{k.replace('\''', '\\\''')}': {recursive_repr(v)}," for k, v in value.items()],
                            "}",
                        ])
                    else:
                        return repr(value)

                with open(os.environ["importsPath"], "r") as f:
                    imports = json.load(f)
                    if imports is not None:
                        for i in imports:
                            print(f"import {i}")
                        print()

                with open(os.environ["valuePath"], "r") as f:
                    for key, value in json.load(f).items():
                        print(f"{key} = {recursive_repr(value)}")
              '';
              passAsFile = [
                "imports"
                "value"
                "pythonGen"
              ];
              preferLocalBuild = true;
            }
            ''
              cat "$valuePath"
              python3 "$pythonGenPath" > $out
              black $out
            ''
        ) { };
    };

  xml =
    {
      format ? "badgerfish",
      withHeader ? true,
    }:
    if format == "badgerfish" then
      {
        type =
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
                description = "XML value";
              };
          in
          valueType;

        generate =
          name: value:
          pkgs.callPackage (
            {
              runCommand,
              libxml2Python,
              python3Packages,
            }:
            runCommand name
              {
                nativeBuildInputs = [
                  python3Packages.xmltodict
                  libxml2Python
                ];
                value = builtins.toJSON value;
                pythonGen = ''
                  import json
                  import os
                  import xmltodict

                  with open(os.environ["valuePath"], "r") as f:
                      print(xmltodict.unparse(json.load(f), full_document=${
                        if withHeader then "True" else "False"
                      }, pretty=True, indent=" " * 2))
                '';
                passAsFile = [
                  "value"
                  "pythonGen"
                ];
                preferLocalBuild = true;
              }
              ''
                python3 "$pythonGenPath" > $out
                xmllint $out > /dev/null
              ''
          ) { };
      }
    else
      throw "pkgs.formats.xml: Unknown format: ${format}";

  plist =
    {
      escape ? true,
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
              path
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "Property list (plist) value";
            };
        in
        valueType;

      generate = name: value: pkgs.writeText name (lib.generators.toPlist { inherit escape; } value);
    };
}
