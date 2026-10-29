{
  lib,
  writeShellApplication,
  fish,
  writeTextFile,
}:

lib.makeOverridable (
  /**
    Creates a wrapped fish shell binary with some plugins, completions,
    configuration snippets and functions sourced from the function
    arguments.

    This can for example be used as a convenient way to test fish plugins
    and scripts without having to alter the environment.

    # Type

    ```pseudocode
    wrapFish :: {
      completionDirs :: [Path] ?,
      functionDirs :: [Path] ?,
      confDirs :: [Path] ?,
      pluginPkgs :: [Derivation] ?,
      localConfig :: String ?,
      shellAliases :: {
        [ N :: T ] :: String
      } ?,
      runtimeInputs :: [Derivation] ?,
    } -> Derivation
    ```

    # Example

    ::: {.example}
    ```nix
    wrapFish {
      pluginPkgs = with fishPlugins; [
        pure
        foreign-env
      ];
      completionDirs = [ ];
      functionDirs = [ ];
      confDirs = [ "/path/to/some/fish/init/dir/" ];
      shellAliases = {
        hello = "echo 'Hello World!'";
        bye = "echo 'Bye World!'; exit";
      };
      runtimeInputs = with pkgs; [
        curl
        w3m
      ];
    }
    ```
    :::

    # Arguments

    All arguments are optional.

    ## `completionDirs` (list of paths)

    Directories containing fish completions which will be prepended to
    {env}`fish_complete_paths` in the environment of the resulting wrapped
    fish binary.

    ## `functionDirs` (list of paths)

    Directories containing fish functions which will be prepended to
    {env}`fish_function_path` in the environment of the resulting wrapped
    fish binary.

    ## `confDirs` (list of paths)

    Directories containing fish code which will be sourced by the resulting
    wrapped fish binary.

    ## `pluginPkgs` (list of derivations)

    Derivations, usually from the package set `fishPlugins`, that will be
    added to the resulting wrapped fish binary.

    ## `localConfig` (string)

    String containing a fish script which will be sourced by the resulting
    wrapped fish binary.

    ## `shellAliases` (attribute set of strings)

    Shell aliases that will be made available in the resulting wrapped fish
    binary.

    ## `runtimeInputs` (list of derivations)

    A list of Derivations that will be added to the {env}`PATH` of the
    resulting wrapped fish binary.
  */
  {
    completionDirs ? [ ],
    functionDirs ? [ ],
    confDirs ? [ ],
    pluginPkgs ? [ ],
    localConfig ? "",
    shellAliases ? { },
    runtimeInputs ? [ ],
  }:

  let
    aliasesStr = builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (k: v: "alias ${k} ${lib.escapeShellArg v}") shellAliases
    );

    shellAliasesFishConfig = writeTextFile {
      name = "wrapfish.aliases.fish";
      destination = "/share/fish/vendor_conf.d/aliases.fish";
      text = ''
        status is-interactive; and begin
          # Aliases
          ${aliasesStr}
        end
      '';
    };

    localFishConfig = writeTextFile {
      name = "wrapfish.local.fish";
      destination = "/share/fish/vendor_conf.d/config.local.fish";
      text = localConfig;
    };

    vendorDir = kind: plugin: "${plugin}/share/fish/vendor_${kind}.d";
    complPath = completionDirs ++ map (vendorDir "completions") pluginPkgs;
    funcPath = functionDirs ++ map (vendorDir "functions") pluginPkgs;
    confPath =
      confDirs
      ++ (map (vendorDir "conf") pluginPkgs)
      ++ (map (vendorDir "conf") [
        localFishConfig
        shellAliasesFishConfig
      ]);

  in
  writeShellApplication {
    inherit runtimeInputs;
    name = "fish";
    text = ''
      ${fish}/bin/fish --init-command "
        set --prepend fish_complete_path ${lib.escapeShellArgs complPath}
        set --prepend fish_function_path ${lib.escapeShellArgs funcPath}
        set --local fish_conf_source_path ${lib.escapeShellArgs confPath}
        for c in \$fish_conf_source_path/*; source \$c; end
      " "$@"
    '';
  }
)
