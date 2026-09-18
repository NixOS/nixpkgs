# Tests in: ./tests/generated-files.nix
{ lib, pkgs }:

/**
  A module system type for a file that Nix generates, and a builder that
  collects a set of such files into one directory.

  An option of this type holds the content of the file, and the store path
  that holds it. It does not hold the location where the file is installed.
  The consumer of the option decides that location. Thus this type is usable
  for `/etc` files, for files in a wrapper, and for files in a container
  image.

  Give the content as `text`, and `source` becomes a store path with that
  content. Give `source` directly to use a file that already exists. A bare
  path is also a valid definition, and is the same as `{ source = <path>; }`.
  An option of this type is thus a drop-in replacement for an option of type
  `path`.

  Use `extraModules` to add options to the file, for example a file mode.

  # Inputs

  `namePrefix`
  : Prefix for the name of the derivation that `source` defaults to. Use a
    prefix that identifies the option, because the store path name is the
    only clue in a build log.

  `relativeTo`
  : Name of the directory that `target` is relative to, for the
    documentation of `target`. Use the syntax of an option description.

  `extraModules`
  : Modules to add to the file. Use these to declare more options, for
    example the mode of the installed file. A module is able to read `name`,
    the attribute name of the file.

  # Type

  ```
  generatedFiles :: {
    namePrefix :: String,
    relativeTo :: String,
    extraModules :: [ Module ],
  } -> {
    type :: Type,
    toDirectory :: String -> AttrsOf File -> Derivation,
  }
  ```

  # Outputs

  `type`
  : The module system type of one file.

  `toDirectory`
  : Function that takes a derivation name and a set of files, and returns a
    directory that holds the files. It leaves out the files that `enable` is
    `false` for, and it puts each file at its own `target`.

  # Examples
  :::{.example}
  ## `pkgs.generatedFiles` usage example

  ```nix
  let
    settingsFiles = pkgs.generatedFiles {
      namePrefix = "my-program";
      relativeTo = "{file}`/etc/my-program`";
    };
  in
  {
    options.myProgram.settingsFiles = lib.mkOption {
      type = lib.types.attrsOf settingsFiles.type;
      default = { };
    };

    config.environment.etc."my-program".source =
      settingsFiles.toDirectory "my-program-config" config.myProgram.settingsFiles;
  }
  ```

  ```nix
  myProgram.settingsFiles."conf.d/main.ini".text = "verbose = true";
  ```

  The file is then available as
  `config.myProgram.settingsFiles."conf.d/main.ini".source`, and at
  {file}`/etc/my-program/conf.d/main.ini`.
  :::

  :::{.example}
  ## `pkgs.generatedFiles` extension example

  ```nix
  pkgs.generatedFiles {
    namePrefix = "my-program";
    extraModules = [
      {
        options.mode = lib.mkOption {
          type = lib.types.str;
          default = "0444";
          description = "Mode of the installed file.";
        };
      }
    ];
  }
  ```
  :::
*/
{
  namePrefix ? "file",
  relativeTo ? "the directory that the consumer of this option puts the file in",
  extraModules ? [ ],
}:
{
  type = lib.types.coercedTo lib.types.path (source: { inherit source; }) (
    lib.types.submodule (
      [
        (
          {
            name,
            config,
            options,
            ...
          }:
          {
            options = {
              enable = lib.mkOption {
                type = lib.types.bool;
                default = true;
                description = ''
                  Whether to generate this file.
                  Set this to `false` to disable one file of a set.
                '';
              };

              target = lib.mkOption {
                type = lib.types.str;
                description = ''
                  Name of the file, relative to ${relativeTo}. Defaults to the
                  attribute name.

                  The name is able to contain `/`, to put the file in a
                  subdirectory.
                '';
              };

              text = lib.mkOption {
                type = lib.types.nullOr lib.types.lines;
                default = null;
                description = ''
                  Content of the file. If this is not `null`, `source` defaults
                  to a store path with this content.
                '';
              };

              source = lib.mkOption {
                type = lib.types.path;
                description = ''
                  Store path that holds the content of the file.
                '';
              };
            };

            config = {
              target = lib.mkDefault name;
              source = lib.mkIf (config.text != null) (
                let
                  name' = namePrefix + "-" + lib.replaceStrings [ "/" ] [ "-" ] name;
                in
                lib.mkDerivedConfig options.text (pkgs.writeText name')
              );
            };
          }
        )
      ]
      ++ extraModules
    )
  );

  toDirectory =
    name: files:
    pkgs.linkFarm name (
      lib.mapAttrs' (_name: file: lib.nameValuePair file.target file.source) (
        lib.filterAttrs (_name: file: file.enable) files
      )
    );
}
