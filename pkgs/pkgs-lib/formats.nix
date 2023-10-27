{ lib, pkgs }:
let
  mkSystemdCredentials = baseName: secrets:
    (builtins.foldl'
      (state: secret:
        {
          credentials =
            if secret.type == "file-content" || secret.type == "file-path" then {
              LoadCredential = (state.credentials.LoadCredential or []) ++ [
                "${baseName}-${toString state.count}:${secret.path}"
              ];
            }
            else if secret.type == "file-content-encrypted" then {
              LoadCredentialEncrypted = (state.credentials.LoadCredentialEncrypted or []) ++ [
                "${baseName}-${toString state.count}:${secret.path}"
              ];
            }
            else throw "unrecognized secret type: ${secret.type}";
          count = state.count + 1;
        })
      { count = 1; credentials = {}; }
      secrets).credentials;
in
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

      # configWithSecrets :: Path -> Config -> AttrSet
      # Runtime secret substitution support for the format (optional).
      # Takes the file's target path and the config to export, and
      # returns an attribute set with two attributes:
      # systemdServiceConfig and creationScript. systemdServiceConfig
      # contains attributes to be merged into a systemd
      # service's serviceConfig section, e.g. LoadCredential.
      # creationScript is a script which creates the config at
      # runtime, with the secrets substituted in, and should be run in
      # the context of a systemd service.
      configWithSecrets :: Path -> Config -> {
        systemdServiceConfig = ...;
        creationScript = ...;
      }

    });
  */


  inherit (import ./formats/java-properties/default.nix { inherit lib pkgs; })
    javaProperties;

  json = {}: rec {

    type = with lib.types; let
      valueType = nullOr (oneOf [
        bool
        int
        float
        str
        path
        secret
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

    configWithSecrets = path: config:
      let /*
        Recurse into a list or an attrset, searching for secrets, and
        return an attrset where the names are the corresponding jq
        path where the attrs were found and the values are the values
        of the attrs.

        Example:
          getSecretsWithJqPrefix
            {
              example = [
                {
                  irrelevant = "not interesting";
                }
                {
                  ignored = "ignored attr";
                  relevant = {
                    secret = lib.mkSecret "/path/to/secret";
                  };
                }
              ];
            }
            -> { ".example[1].relevant.secret" = "/path/to/secret"; }   */
        getSecretsWithJqPrefix = item:
          let
            escapeName = name: ''"${lib.replaceStrings [''"'' "\\"] [''\"'' "\\\\"] name}"'';
            recurse = prefix: item:
              if lib.isSecret item then
                [ (lib.nameValuePair prefix item._secret) ]
              else if builtins.isAttrs item then
                lib.concatLists (
                  lib.mapAttrsToList
                    (name: value: recurse (prefix + "." + (escapeName name)) value)
                    item
                )
              else if builtins.isList item then
                lib.concatLists (
                  lib.imap0
                    (index: item: recurse (prefix + "[${toString index}]") item)
                    item
                )
              else
                [];
          in lib.listToAttrs (recurse "" item);

        secrets = getSecretsWithJqPrefix config;

        mkSecretReplacement = index: name:
          let
            inherit (secrets.${name}) type;
            credPath = "$CREDENTIALS_DIRECTORY/secret-${builtins.hashString "sha1" path}-${toString index}";
          in
          if type == "file-path" then ''
            ${pkgs.jaq}/bin/jaq --rawfile secret <(echo -n ${credPath}) \
                                ${lib.escapeShellArg "${name} = $secret"} \
                                -i ${lib.escapeShellArg path}
          ''
          else if type == "file-content" || type == "file-content-encrypted" then ''
            ${pkgs.jaq}/bin/jaq --rawfile secret ${credPath} \
                                ${lib.escapeShellArg "${name} = $secret"} \
                                -i ${lib.escapeShellArg path}
          ''
          else throw "unrecognized secret type: ${type}";

        configFile = generate path config;
      in
      {
        systemdServiceConfig = mkSystemdCredentials "secret-${builtins.hashString "sha1" path}" (builtins.attrValues secrets);
        # Extract secrets from the settings and generate a script which
        # creates the config file with the secrets substituted in.
        creationScript = pkgs.writeScript "${path}-secrets-replacement.sh" ''
          set -o errexit -o pipefail -o nounset -o errtrace
          shopt -s inherit_errexit

          umask u=rwx,g=,o=
          cp ${configFile} ${lib.escapeShellArg path}
          ${lib.concatStringsSep "\n" (lib.imap1 mkSecretReplacement (builtins.attrNames secrets))}
        '';
      };
  };

  yaml = {}@args: {

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

    # Extract secrets from the settings and generate a script which
    # performs the secret replacements.
    configWithSecrets = path: config:
      let
        configWithSecretsJSON = (json args).configWithSecrets "${path}-tmp" config;
      in
      configWithSecretsJSON // {
        creationScript = pkgs.writeScript "${path}-secrets-replacement.sh" ''
          set -o errexit -o pipefail -o nounset -o errtrace
          shopt -s inherit_errexit

          umask u=rwx,g=,o=
          ${configWithSecretsJSON.creationScript}
          ${pkgs.remarshal}/bin/json2yaml ${lib.escapeShellArgs [ "${path}-tmp" path ]}
          rm "${path}-tmp"
        '';
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
    rec {

    type = with lib.types; let

      singleIniAtom = nullOr (oneOf [
        bool
        int
        float
        str
        secret
      ]) // {
        description = "INI atom (null, bool, int, float, string or secret)";
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

    # Extract secrets from the settings and generate a script which
    # performs the secret replacements.
    configWithSecrets = path: config:
      let
        secrets = lib.catAttrs "_secret" (lib.collect lib.isSecret config);
        configFile = generate path config;
        mkSecretReplacement = index: secret: ''
          ${pkgs.replace-secret}/bin/replace-secret \
             ${builtins.hashString "sha256" secret.path} \
             ${if secret.type == "file-path" then
                 ''<(echo "$CREDENTIALS_DIRECTORY/secret-${builtins.hashString "sha1" path}-${toString index}")''
               else if secret.type == "file-content" || secret.type == "file-content-encrypted" then
                 ''"$CREDENTIALS_DIRECTORY/secret-${builtins.hashString "sha1" path}-${toString index}"''
               else throw "unrecognized secret type: ${secret.type}"} \
             ${lib.escapeShellArg path}
        '';
      in
        {
          systemdServiceConfig = mkSystemdCredentials "secret-${builtins.hashString "sha1" path}" secrets;
          creationScript = pkgs.writeScript "${path}-secrets-replacement.sh" ''
            set -o errexit -o pipefail -o nounset -o errtrace
            shopt -s inherit_errexit

            umask u=rwx,g=,o=
            cp ${configFile} ${path}
            ${lib.concatStrings (lib.imap1 mkSecretReplacement secrets)}
          '';
        };
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

  toml = {}@args: json args // {
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

    # Extract secrets from the settings and generate a script which
    # performs the secret replacements.
    configWithSecrets = path: config:
      let
        configWithSecretsJSON = (json args).configWithSecrets "${path}-tmp" config;
      in
      configWithSecretsJSON // {
        creationScript = pkgs.writeScript "${path}-secrets-replacement.sh" ''
          set -o errexit -o pipefail -o nounset -o errtrace
          shopt -s inherit_errexit

          umask u=rwx,g=,o=
          ${configWithSecretsJSON.creationScript}
          ${pkgs.remarshal}/bin/json2toml ${lib.escapeShellArgs [ "${path}-tmp" path ]}
          rm "${path}-tmp"
        '';
      };
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
