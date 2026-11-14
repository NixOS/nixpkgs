{ pkgs }:
let
  inherit (pkgs) lib;

  demo = pkgs.configFiles {
    name = "pkgs-lib-test";
    moduleFiles = [ ./config-files-program.nix ];
  };

  extendedDemo = pkgs.configFiles {
    name = "pkgs-lib-test";
    moduleFiles = [ ./config-files-program.nix ];
    extraFileModules = [
      {
        options.mode = lib.mkOption {
          type = lib.types.str;
          default = "0444";
        };
      }
    ];
  };

  # The same file twice, which must evaluate once.
  twice = pkgs.configFiles {
    name = "pkgs-lib-test";
    moduleFiles = [
      ./config-files-program.nix
      ./config-files-program.nix
    ];
  };

  # The set of `nixos/lib/eval-cacheable-options.nix`, which has no packages.
  sandboxPkgs = lib.fix (
    self:
    import ../. {
      inherit lib;
      pkgs = self;
    }
  );

  withPackage =
    configFiles:
    (configFiles {
      name = "pkgs-lib-test";
      moduleFiles = [ ./config-files-package.nix ];
    }).eval
      { };

  settings = {
    settings.main.verbose = true;
  };

  standalone = demo.eval settings;

  # The same modules, in an evaluation that holds more than the program, as
  # NixOS does.
  embedded =
    (lib.evalModules {
      modules = [
        {
          options.program = lib.mkOption {
            type = lib.types.submoduleWith {
              modules = [
                demo.module
                { options.enable = lib.mkEnableOption "the program"; }
              ];
            };
            default = { };
          };
        }
        {
          program = settings // {
            enable = true;
          };
        }
      ];
    }).config.program;

  # A module that declares an option in `portable` next to the options of
  # `configFiles`, as a module that writes a command line does. Such a module
  # can read its own option from `options`.
  withArgv = lib.evalModules {
    modules = [
      demo.module
      settings
      (
        { config, lib, ... }:
        {
          options.portable.argv = lib.mkOption {
            type = lib.types.listOf lib.types.str;
          };

          config.portable.argv = [
            "--config"
            "${config.portable.directory}/main.ini"
          ];
        }
      )
    ];
  };

  extended = extendedDemo.eval (
    settings
    // {
      portable.files."main.ini".mode = "0600";
    }
  );

  # Throw for every check that fails, otherwise build an empty derivation.
  checkAll =
    name: checks:
    pkgs.runCommand name { } (
      lib.foldl' (
        script: check: lib.throwIfNot check.ok "${name}: ${check.msg}" script
      ) "touch $out\n" checks
    );
in
{
  attributes = checkAll "pkgs-lib-config-files-attributes" [
    {
      ok = standalone.portable.files."main.ini".source == embedded.portable.files."main.ini".source;
      msg = "a standalone evaluation and an embedded one build different files";
    }
    {
      ok = standalone.portable.directory == embedded.portable.directory;
      msg = "a standalone evaluation and an embedded one build different directories";
    }
    {
      ok = embedded.enable;
      msg = "an option next to `module` loses its definition";
    }
    {
      ok = !standalone.portable.files."extra.conf".enable;
      msg = "a file that the program turns off stays on";
    }
    {
      ok =
        standalone.portable.entries == {
          "main.ini" = standalone.portable.files."main.ini".source;
        };
      msg = "`portable.entries` does not hold exactly the enabled files";
    }
    {
      ok = standalone.portable.directory.entries == standalone.portable.entries;
      msg = "the directory does not give `portable.entries` as `entries`";
    }
    {
      ok = extended.portable.files."main.ini".mode == "0600";
      msg = "an option of `extraFileModules` does not reach the files";
    }
    {
      ok =
        withArgv.options.portable.argv.value == [
          "--config"
          "${standalone.portable.directory}/main.ini"
        ];
      msg = "a module cannot declare an option in `portable`";
    }
    {
      ok = (twice.eval settings).portable.directory == standalone.portable.directory;
      msg = "a file in `moduleFiles` that occurs twice does not evaluate once";
    }
    {
      ok = (withPackage pkgs.configFiles).package == pkgs.hello;
      msg = "a file in `moduleFiles` does not get its argument from `pkgs`";
    }
    {
      ok = (withPackage sandboxPkgs.configFiles).settings == { };
      msg = "a set without packages cannot evaluate a file that needs a package";
    }
    {
      ok = !withArgv._module.args ? pkgs;
      msg = "the module gives `pkgs` to the modules next to it";
    }
    {
      ok = lib.hasSuffix "-pkgs-lib-test-config" standalone.portable.directory;
      msg = "the directory does not take its name from `name`";
    }
  ];

  directory =
    pkgs.runCommand "pkgs-lib-config-files-directory" { dir = standalone.portable.directory; }
      ''
            fail() {
              echo "$1"
              find "$dir/" | sort
              exit 1
            }

            [ "$(cat "$dir/main.ini")" = "[main]
        verbose=true" ] || fail "the directory leaves out a file that the program sets"
            [ ! -e "$dir/extra.conf" ] || fail "the directory holds a file that the program turns off"
            touch "$out"
      '';
}
