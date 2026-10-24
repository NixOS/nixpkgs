{ pkgs }:
let
  inherit (pkgs) lib;

  files = pkgs.generatedFiles { namePrefix = "pkgs-lib-test"; };

  # Evaluate `defs` as an `attrsOf type` option, and return the resulting
  # config.
  evalAs =
    type: defs:
    (lib.evalModules {
      modules = [
        {
          options.files = lib.mkOption {
            type = lib.types.attrsOf type;
            default = { };
          };
        }
        { files = defs; }
      ];
    }).config.files;

  eval = evalAs files.type;

  # Throw for every check that fails, otherwise build an empty derivation.
  checkAll =
    name: checks:
    pkgs.runCommand name { } (
      lib.foldl' (
        script: check: lib.throwIfNot check.ok "${name}: ${check.msg}" script
      ) "touch $out\n" checks
    );

  # Compare the content of a `source` against the expected text.
  checkContent =
    name: source: expected:
    pkgs.runCommand name
      {
        passAsFile = [ "expected" ];
        inherit expected source;
      }
      ''
        if diff -u "$expectedPath" "$source"; then
          touch "$out"
        else
          echo
          echo "The file holds different content than expected; diff above."
          exit 1
        fi
      '';

  derived = eval {
    "hello.conf".text = "greeting = hello\n";
    "conf.d/main.ini".text = "verbose = true\n";
  };

  explicit = eval {
    "preexisting.conf".source = pkgs.writeText "some-other-name" "already = built\n";
  };

  # A bare path is the same as `{ source = <path>; }`, so that an option of
  # this type replaces an option of type `path`.
  coerced = eval {
    "coerced.conf" = pkgs.writeText "coerced-source" "coerced = true\n";
  };

  renamed = eval {
    "attribute-name".target = "other-name";
  };

  disabled = eval {
    "off.conf" = {
      enable = false;
      text = "";
    };
  };

  extendedFiles = pkgs.generatedFiles {
    namePrefix = "pkgs-lib-test";
    extraModules = [
      {
        options.mode = lib.mkOption {
          type = lib.types.str;
          default = "0444";
          description = "Mode of the installed file.";
        };
      }
    ];
  };

  extended = evalAs extendedFiles.type {
    "extended.conf" = {
      text = "extended = true\n";
      mode = "0600";
    };
    "default-mode.conf".text = "";
  };

  directory = files.toDirectory "pkgs-lib-test-directory" (eval {
    "kept.conf".text = "kept = true\n";
    "nested/deep.conf".text = "deep = true\n";
    "renamed.conf" = {
      target = "under/other-name.conf";
      text = "renamed = true\n";
    };
    "dropped.conf" = {
      enable = false;
      text = "dropped = true\n";
    };
  });
in
{
  derived-text =
    checkContent "pkgs-lib-files-derived-text" derived."hello.conf".source
      "greeting = hello\n";

  derived-text-in-subdirectory =
    checkContent "pkgs-lib-files-derived-text-in-subdirectory" derived."conf.d/main.ini".source
      "verbose = true\n";

  explicit-source =
    checkContent "pkgs-lib-files-explicit-source" explicit."preexisting.conf".source
      "already = built\n";

  coerced-path =
    checkContent "pkgs-lib-files-coerced-path" coerced."coerced.conf".source
      "coerced = true\n";

  extended-text =
    checkContent "pkgs-lib-files-extended-text" extended."extended.conf".source
      "extended = true\n";

  attributes = checkAll "pkgs-lib-files-attributes" [
    {
      ok = derived."hello.conf".target == "hello.conf";
      msg = "`target` does not default to the attribute name";
    }
    {
      ok = derived."conf.d/main.ini".target == "conf.d/main.ini";
      msg = "`target` drops the subdirectory of the attribute name";
    }
    {
      ok = renamed."attribute-name".target == "other-name";
      msg = "an explicit `target` does not replace the attribute name";
    }
    {
      ok = derived."hello.conf".enable;
      msg = "`enable` does not default to `true`";
    }
    {
      ok = !disabled."off.conf".enable;
      msg = "`enable` keeps its default against an explicit `false`";
    }
    {
      ok = coerced."coerced.conf".enable && coerced."coerced.conf".target == "coerced.conf";
      msg = "a bare path does not get the defaults of the other options";
    }
    {
      # The name of the derivation is the only clue about a file in a build
      # log, so it holds the prefix and the full attribute name.
      ok = lib.hasSuffix "-pkgs-lib-test-conf.d-main.ini" derived."conf.d/main.ini".source;
      msg = "the derivation name does not replace `/` in the attribute name";
    }
    {
      ok = lib.hasSuffix "-some-other-name" explicit."preexisting.conf".source;
      msg = "an explicit `source` does not keep its own derivation name";
    }
  ];

  extended-attributes = checkAll "pkgs-lib-files-extended-attributes" [
    {
      ok = extended."extended.conf".mode == "0600";
      msg = "an option of `extraModules` does not hold its definition";
    }
    {
      ok = extended."default-mode.conf".mode == "0444";
      msg = "an option of `extraModules` does not hold its default";
    }
    {
      ok = extended."extended.conf".target == "extended.conf";
      msg = "`extraModules` removes the default of `target`";
    }
    {
      ok = lib.hasSuffix "-pkgs-lib-test-default-mode.conf" extended."default-mode.conf".source;
      msg = "`extraModules` removes the derived `source`";
    }
  ];

  to-directory = pkgs.runCommand "pkgs-lib-files-to-directory" { dir = directory; } ''
    fail() {
      echo "$1"
      find "$dir/" | sort
      exit 1
    }

    [ "$(cat "$dir/kept.conf")" = "kept = true" ] || fail "toDirectory leaves out an enabled file"
    [ "$(cat "$dir/nested/deep.conf")" = "deep = true" ] || fail "toDirectory flattens a nested target"
    [ "$(cat "$dir/under/other-name.conf")" = "renamed = true" ] || fail "toDirectory ignores target"
    [ ! -e "$dir/dropped.conf" ] || fail "toDirectory keeps a disabled file"

    touch "$out"
  '';
}
