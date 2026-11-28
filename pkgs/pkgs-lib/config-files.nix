# Tests in: ./tests/config-files.nix
{ lib, pkgs }:

/**
  A module system evaluation that maps options to the configuration files of a
  program.

  A program takes its configuration from one or more files. The options that
  describe that configuration, and the code that writes the files, belong
  together, and they do not depend on NixOS. This function puts that pair in a
  module that any system is able to evaluate.

  Write the inputs of this function in a `config-files.nix` file in the
  directory of the package, and the modules in more files next to it. The
  package exposes the result as `passthru.configFiles`, and the file of the
  program as `passthru.configModule`. A NixOS module imports `config-files.nix`
  by path, puts `module` next to the options that only NixOS has, and does not
  repeat the declarations. A system that is not NixOS calls `eval` and gets the
  same files.

  The NixOS module does not use the attribute of the package, because NixOS
  evaluates the types of all options, also when the service is not enabled,
  and the sandbox that builds the option documentation has no packages. Thus
  an overlay that changes `passthru.configFiles` of the package does not
  change the NixOS options. The sandbox has the files only if
  `configFilesPackages` in `nixos/modules/misc/documentation.nix` has the
  directory of the package.

  The evaluation does not give a `pkgs` module argument, because a modular
  service must not get the complete package set from the modules that it
  imports. A module that needs a package goes in `moduleFiles`. Such a file is
  a function that takes the packages that it needs and returns a module, as
  the `service.nix` file of a modular service is. This function gets each
  argument from `pkgs` by name, and only when the module uses the value. Thus
  the sandbox can evaluate the options of a module that needs a package only to
  build its files.

  A type cannot depend on the value of an option. Thus, if the user sets the
  `package` option of a NixOS service to a different version of the program,
  the options do not change.

  The evaluation adds a `portable.files` option, of the type that
  `pkgs.generatedFiles` gives, and two read-only outputs of those files:
  `portable.entries`, from the `target` to the `source` of each enabled file,
  and `portable.directory`, that holds the files at those paths. Use
  `portable.entries` to read the files without the cost of a directory. A
  module sets `portable.files`, and reads the options that it declares
  itself. The `portable` prefix keeps these options apart from the options of
  the program, and from the options that NixOS adds next to them. `portable`
  is not a submodule, thus other modules can declare more options in it.

  # Inputs

  `name`
  : Name of the program. It is the prefix of the name of every derivation
    that the evaluation builds.

  `modules`
  : Modules that declare the options of the program, and that set
    `portable.files` from them.

  `moduleFiles`
  : Paths of files that do the same as `modules`, for a module that needs
    packages. Each file has the form `{ formats }: { config, lib, ... }: { }`.
    The first function asks for attributes of `pkgs`. A default value of an
    argument of this function has no effect. A path that occurs more than once
    evaluates once.

  `extraFileModules`
  : Modules to add to every file, as `extraModules` of `pkgs.generatedFiles`.

  # Type

  ```
  configFiles :: {
    name :: String,
    modules :: [ Module ],
    moduleFiles :: [ Path ],
    extraFileModules :: [ Module ],
  } -> {
    module :: Module,
    type :: Type,
    eval :: ([ Module ] | Module) -> AttrSet,
    files :: {
      type :: Type,
      toEntries :: AttrsOf File -> AttrsOf Path,
      toDirectory :: String -> AttrsOf File -> Derivation,
    },
  }
  ```

  # Outputs

  `module`
  : The whole configuration as one module. Add it to the module list of a
    submodule to put the configuration of the program next to the options of
    a larger module system evaluation, such as the `enable` option of a NixOS
    service.

  `type`
  : Module system type of the whole configuration. Declare an option of this
    type to put the configuration of the program in a larger module system
    evaluation that adds no options of its own.

  `eval`
  : Function that takes modules and returns the configuration of the
    evaluation. Use this outside of a module system evaluation. The result
    holds the options that the program declares, and `portable`.

  `files`
  : The `pkgs.generatedFiles` result that `portable.files` uses. Use it to build a
    directory of a subset of the files.

  # Examples
  :::{.example}
  ## `pkgs.configFiles` usage example

  The inputs and the module are in the directory of the package:

  ```nix
  # pkgs/by-name/my/my-program/config-files.nix
  {
    name = "my-program";
    moduleFiles = [ ./config-module.nix ];
  }
  ```

  ```nix
  # pkgs/by-name/my/my-program/config-module.nix
  { formats }:

  { lib, config, ... }:
  let
    format = formats.ini { };
  in
  {
    options.settings = lib.mkOption {
      type = format.type;
      default = { };
      description = "Configuration of my-program.";
    };

    config.portable.files."main.ini" = {
      inherit format;
      value = config.settings;
    };
  }
  ```

  The package exposes the result, and the file of the program:

  ```nix
  # pkgs/by-name/my/my-program/package.nix
  { configFiles, stdenv }:
  stdenv.mkDerivation {
    passthru.configFiles = configFiles (import ./config-files.nix);
    passthru.configModule = ./config-module.nix;
  }
  ```

  A NixOS module imports the inputs, puts the module next to its own options,
  and takes the files from it:

  ```nix
  {
    options.services.myProgram = lib.mkOption {
      default = { };
      description = "my-program, a program.";
      type = lib.types.submoduleWith {
        modules = [
          (pkgs.configFiles (import ../../../../pkgs/by-name/my/my-program/config-files.nix)).module
          { options.enable = lib.mkEnableOption "my-program"; }
        ];
      };
    };

    config = lib.mkIf config.services.myProgram.enable {
      environment.etc."my-program".source = config.services.myProgram.portable.directory;
    };
  }
  ```

  A system that is not NixOS builds the same directory:

  ```nix
  (pkgs.my-program.configFiles.eval { settings.verbose = true; }).portable.directory
  ```

  A different call uses the file of the program with other inputs, for example
  to add an option to every file. The file is not a module, thus give it to
  `moduleFiles`, and not to `imports`:

  ```nix
  pkgs.configFiles {
    name = "my-program";
    moduleFiles = [ pkgs.my-program.configModule ];
    extraFileModules = [
      {
        options.mode = lib.mkOption {
          type = lib.types.str;
          default = "0444";
        };
      }
    ];
  }
  ```
  :::
*/
{
  name,
  modules ? [ ],
  moduleFiles ? [ ],
  extraFileModules ? [ ],
}:
let
  # Do not use `callPackage`. The sandbox that builds the option documentation
  # does not have it, and it has no packages. Thus each attribute must stay
  # unevaluated until a module uses it.
  #
  # The module system cannot see that two applied files are the same. `key`
  # tells it.
  applyModuleFile = file: {
    key = toString file;
    imports = [
      (lib.modules.importApply file (
        lib.mapAttrs (dependency: _: pkgs.${dependency}) (lib.functionArgs (import file))
      ))
    ];
  };

  files = pkgs.generatedFiles {
    namePrefix = name;
    extraModules = extraFileModules;
  };

  base =
    { config, ... }:
    {
      # Plain options, and not one submodule option, so that other modules can
      # declare more options in `portable`.
      options.portable = {
        files = lib.mkOption {
          type = lib.types.attrsOf files.type;
          default = { };
          description = ''
            Configuration files of the program. The modules of the program set
            this from the options that they declare.
          '';
        };

        entries = lib.mkOption {
          type = lib.types.attrsOf lib.types.path;
          readOnly = true;
          description = ''
            The `source` of each enabled file of `portable.files`, by its
            `target`. Reading this builds nothing.
          '';
        };

        directory = lib.mkOption {
          type = lib.types.package;
          readOnly = true;
          description = ''
            Directory that holds the files of `portable.files`, each at its own
            `target`.
          '';
        };
      };

      config.portable = {
        entries = files.toEntries config.portable.files;
        directory = pkgs.linkFarm "${name}-config" config.portable.entries;
      };
    };
in
rec {
  inherit files;

  module = {
    imports = [ base ] ++ modules ++ map applyModuleFile moduleFiles;
  };

  type = lib.types.submoduleWith {
    modules = [ module ];
  };

  eval =
    modules:
    (lib.evalModules {
      modules = [ module ] ++ lib.toList modules;
    }).config;
}
