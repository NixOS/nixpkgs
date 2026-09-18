{ pkgs }:
let
  inherit (pkgs) lib;

  # A program module, of the kind that a package puts in its `passthru`. It
  # takes `pkgs` as a module argument, to show that `configFiles` gives it.
  programModule =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    let
      format = pkgs.formats.ini { };
    in
    {
      options.settings = lib.mkOption {
        type = lib.types.submodule { freeformType = format.type; };
        default = { };
      };

      options.extraConfig = lib.mkOption {
        type = lib.types.lines;
        default = "";
      };

      config.portable.files = {
        "main.ini".source = format.generate "main.ini" config.settings;
        "extra.conf" = {
          enable = config.extraConfig != "";
          text = config.extraConfig;
        };
      };
    };

  demo = pkgs.configFiles {
    name = "pkgs-lib-test";
    modules = [ programModule ];
  };

  extendedDemo = pkgs.configFiles {
    name = "pkgs-lib-test";
    modules = [ programModule ];
    extraFileModules = [
      {
        options.mode = lib.mkOption {
          type = lib.types.str;
          default = "0444";
        };
      }
    ];
  };

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
      ok = extended.portable.files."main.ini".mode == "0600";
      msg = "an option of `extraFileModules` does not reach the files";
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
