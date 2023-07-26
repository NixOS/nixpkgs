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
        # We check the input values, so that
        #  - we don't write nonsensical tests that will impede progress
        #  - the test author has a slightly more realistic view of the
        #    final format during development.
        value = lib.throwIfNot (formatSet.type.check def) (builtins.trace def "definition does not pass the type's check function") def;
        file = "def${toString n}";
      }) [ def ]);
    in formatSet.generate "test-format-file" config;

  runBuildTest = name: { drv, expected }: pkgs.runCommand name {
    passAsFile = ["expected"];
    inherit expected drv;
  } ''
    if diff -u "$expectedPath" "$drv"; then
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

  testKeyValueAtoms = {
    drv = evalFormat formats.keyValue {} {
      bool = true;
      int = 10;
      float = 3.141;
      str = "string";
    };
    expected = ''
      bool=true
      float=3.141000
      int=10
      str=string
    '';
  };

  testKeyValueDuplicateKeys = {
    drv = evalFormat formats.keyValue { listsAsDuplicateKeys = true; } {
      bar = [ null true "test" 1.2 10 ];
      baz = false;
      qux = "qux";
    };
    expected = ''
      bar=null
      bar=true
      bar=test
      bar=1.200000
      bar=10
      baz=false
      qux=qux
    '';
  };

  testKeyValueListToValue = {
    drv = evalFormat formats.keyValue { listToValue = concatMapStringsSep ", " (generators.mkValueStringDefault {}); } {
      bar = [ null true "test" 1.2 10 ];
      baz = false;
      qux = "qux";
    };
    expected = ''
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

      [level1.level2.level3]
      level4 = "deep"
    '';
  };

  # This test is responsible for
  #   1. testing type coercions
  #   2. providing a more readable example test
  # Whereas java-properties/default.nix tests the low level escaping, etc.
  testJavaProperties = {
    drv = evalFormat formats.javaProperties {} {
      floaty = 3.1415;
      tautologies = true;
      contradictions = false;
      foo = "bar";
      # # Disallowed at eval time, because it's ambiguous:
      # # add to store or convert to string?
      # root = /root;
      "1" = 2;
      package = pkgs.hello;
      "ütf 8" = "dûh";
      # NB: Some editors (vscode) show this _whole_ line in right-to-left order
      "الجبر" = "أكثر من مجرد أرقام";
    };
    expected = ''
      # Generated with Nix

      1 = 2
      contradictions = false
      floaty = 3.141500
      foo = bar
      package = ${pkgs.hello}
      tautologies = true
      \u00fctf\ 8 = d\u00fbh
      \u0627\u0644\u062c\u0628\u0631 = \u0623\u0643\u062b\u0631 \u0645\u0646 \u0645\u062c\u0631\u062f \u0623\u0631\u0642\u0627\u0645
    '';
  };
}
