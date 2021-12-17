{ pkgs }:
let
  inherit (pkgs) lib formats;
in
with lib;
let

  evalFormat = format: args: def:
    let
      formatSet = format args;
      config = formatSet.type.merge [] (imap1 (n: def: {
        value = def;
        file = "def${toString n}";
      }) [ def ]);
    in formatSet.generate "test-format-file" config;

  runBuildTest = name: { drv, expected }: pkgs.runCommand name {} ''
    if diff -u '${builtins.toFile "expected" expected}' '${drv}'; then
      touch "$out"
    else
      echo
      echo "Got different values than expected; diff above."
      exit 1
    fi
  '';

  runBuildTests = tests: pkgs.linkFarm "nixpkgs-pkgs-lib-format-tests" (mapAttrsToList (name: value: { inherit name; path = runBuildTest name value; }) (filterAttrs (name: value: value != null) tests));

in runBuildTests {

  testJsonAtoms = {
    drv = evalFormat formats.json {} {
      null = null;
      false = false;
      true = true;
      int = 10;
      float = 3.141;
      str = "foo";
      attrs.foo = null;
      list = [ null null ];
      path = ./formats.nix;
    };
    expected = ''
      {
        "attrs": {
          "foo": null
        },
        "false": false,
        "float": 3.141,
        "int": 10,
        "list": [
          null,
          null
        ],
        "null": null,
        "path": "${./formats.nix}",
        "str": "foo",
        "true": true
      }
    '';
  };

  testYamlAtoms = {
    drv = evalFormat formats.yaml {} {
      null = null;
      false = false;
      true = true;
      float = 3.141;
      str = "foo";
      attrs.foo = null;
      list = [ null null ];
      path = ./formats.nix;
    };
    expected = ''
      attrs:
        foo: null
      'false': false
      float: 3.141
      list:
      - null
      - null
      'null': null
      path: ${./formats.nix}
      str: foo
      'true': true
    '';
  };

  testIniAtoms = {
    drv = evalFormat formats.ini {} {
      foo = {
        bool = true;
        int = 10;
        float = 3.141;
        str = "string";
      };
    };
    expected = ''
      [foo]
      bool=true
      float=3.141000
      int=10
      str=string
    '';
  };

  testIniDuplicateKeys = {
    drv = evalFormat formats.ini { listsAsDuplicateKeys = true; } {
      foo = {
        bar = [ null true "test" 1.2 10 ];
        baz = false;
        qux = "qux";
      };
    };
    expected = ''
      [foo]
      bar=null
      bar=true
      bar=test
      bar=1.200000
      bar=10
      baz=false
      qux=qux
    '';
  };

  testIniListToValue = {
    drv = evalFormat formats.ini { listToValue = concatMapStringsSep ", " (generators.mkValueStringDefault {}); } {
      foo = {
        bar = [ null true "test" 1.2 10 ];
        baz = false;
        qux = "qux";
      };
    };
    expected = ''
      [foo]
      bar=null, true, test, 1.200000, 10
      baz=false
      qux=qux
    '';
  };

  testTomlAtoms = {
    drv = evalFormat formats.toml {} {
      false = false;
      true = true;
      int = 10;
      float = 3.141;
      str = "foo";
      attrs.foo = "foo";
      list = [ 1 2 ];
      level1.level2.level3.level4 = "deep";
    };
    expected = ''
      false = false
      float = 3.141
      int = 10
      list = [1, 2]
      str = "foo"
      true = true

      [attrs]
      foo = "foo"

      [level1]
      [level1.level2]
      [level1.level2.level3]
      level4 = "deep"
    '';
  };
}
