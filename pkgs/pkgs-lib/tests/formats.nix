{ pkgs }:
let
  inherit (pkgs) lib formats;

  # merging allows us to add metadata to the input
  # this makes error messages more readable during development
  mergeInput =
    name: format: input:
    format.type.merge
      [ ]
      [
        {
          # explicitly throw here to trigger the code path that prints the error message for users
          value =
            lib.throwIfNot (format.type.check input)
              (builtins.trace input "definition does not pass the type's check function")
              input;
          # inject the name
          file = "format-test-${name}";
        }
      ];

  # run a diff between expected and real output
  runDiff =
    name: drv: expected:
    pkgs.runCommand name
      {
        passAsFile = [ "expected" ];
        inherit expected drv;
      }
      ''
        if diff -u "$expectedPath" "$drv"; then
          touch "$out"
        else
          echo
          echo "Got different values than expected; diff above."
          exit 1
        fi
      '';

  # use this to check for proper serialization
  # in practice you do not have to supply the name parameter as this one will be added by runBuildTests
  shouldPass =
    {
      format,
      input,
      expected,
    }:
    name: {
      name = "pass-${name}";
      path = runDiff "test-format-${name}" (format.generate "test-format-${name}" (
        mergeInput name format input
      )) expected;
    };

  # use this function to assert that a type check must fail
  # in practice you do not have to supply the name parameter as this one will be added by runBuildTests
  # note that as per 352e7d330a26 and 352e7d330a26 the type checking of attrsets and lists are not strict
  # this means that the code below needs to properly merge the module type definition and also evaluate the (lazy) return value
  shouldFail =
    { format, input }:
    name:
    let
      # trigger a deep type check using the module system
      typeCheck = lib.modules.mergeDefinitions [ "tests" name ] format.type [
        {
          file = "format-test-${name}";
          value = input;
        }
      ];
      # actually use the return value to trigger the evaluation
      eval = builtins.tryEval (typeCheck.mergedValue == input);
      # the check failing is what we want, so don't do anything here
      typeFails = pkgs.runCommand "test-format-${name}" { } "touch $out";
      # bail with some verbose information in case the type check passes
      typeSucceeds =
        pkgs.runCommand "test-format-${name}"
          {
            passAsFile = [ "inputText" ];
            testName = name;
            # this will fail if the input contains functions as values
            # however that should get caught by the type check already
            inputText = builtins.toJSON input;
          }
          ''
            echo "Type check $testName passed when it shouldn't."
            echo "The following data was used as input:"
            echo
            cat "$inputTextPath"
            exit 1
          '';
    in
    {
      name = "fail-${name}";
      path = if eval.success then typeSucceeds else typeFails;
    };

  # this function creates a linkFarm for all the tests below such that the results are easily visible in the filesystem after a build
  # the parameters are an attrset of name: test pairs where the name is automatically passed to the test
  # the test therefore is an invocation of ShouldPass or shouldFail with the attrset parameters but *not* the name (which this adds for convenience)
  runBuildTests = (lib.flip lib.pipe) [
    (lib.mapAttrsToList (name: value: value name))
    (pkgs.linkFarm "nixpkgs-pkgs-lib-format-tests")
  ];

in
runBuildTests {

  jsonAtoms = shouldPass {
    format = formats.json { };
    input = {
      null = null;
      false = false;
      true = true;
      int = 10;
      float = 3.141;
      str = "foo";
      attrs.foo = null;
      list = [
        null
        null
      ];
      path = ./testfile;
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
        "path": "${./testfile}",
        "str": "foo",
        "true": true
      }
    '';
  };

  yaml_1_1Atoms = shouldPass {
    format = formats.yaml_1_1 { };
    input = {
      null = null;
      false = false;
      true = true;
      float = 3.141;
      str = "foo";
      attrs.foo = null;
      list = [
        null
        null
      ];
      path = ./testfile;
      no = "no";
      time = "22:30:00";
    };
    expected = ''
      attrs:
        foo: null
      'false': false
      float: 3.141
      list:
      - null
      - null
      'no': 'no'
      'null': null
      path: ${./testfile}
      str: foo
      time: '22:30:00'
      'true': true
    '';
  };

  yaml_1_2Atoms = shouldPass {
    format = formats.yaml_1_2 { };
    input = {
      null = null;
      false = false;
      true = true;
      float = 3.141;
      str = "foo";
      attrs.foo = null;
      list = [
        null
        null
      ];
      path = ./testfile;
      no = "no";
      time = "22:30:00";
    };
    expected = ''
      attrs:
        foo: null
      'false': false
      float: 3.141
      list:
      - null
      - null
      no: no
      'null': null
      path: ${./testfile}
      str: foo
      time: 22:30:00
      'true': true
    '';
  };

  iniAtoms = shouldPass {
    format = formats.ini { };
    input = {
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

  iniInvalidAtom = shouldFail {
    format = formats.ini { };
    input = {
      foo = {
        function = _: 1;
      };
    };
  };

  iniDuplicateKeysWithoutList = shouldFail {
    format = formats.ini { };
    input = {
      foo = {
        bar = [
          null
          true
          "test"
          1.2
          10
        ];
        baz = false;
        qux = "qux";
      };
    };
  };

  iniDuplicateKeys = shouldPass {
    format = formats.ini { listsAsDuplicateKeys = true; };
    input = {
      foo = {
        bar = [
          null
          true
          "test"
          1.2
          10
        ];
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

  iniListToValue = shouldPass {
    format = formats.ini {
      listToValue = lib.concatMapStringsSep ", " (lib.generators.mkValueStringDefault { });
    };
    input = {
      foo = {
        bar = [
          null
          true
          "test"
          1.2
          10
        ];
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

  iniCoercedDuplicateKeys = shouldPass rec {
    format = formats.ini {
      listsAsDuplicateKeys = true;
      atomsCoercedToLists = true;
    };
    input =
      format.type.merge
        [ ]
        [
          {
            file = "format-test-inner-iniCoercedDuplicateKeys";
            value = {
              foo = {
                bar = 1;
              };
            };
          }
          {
            file = "format-test-inner-iniCoercedDuplicateKeys";
            value = {
              foo = {
                bar = 2;
              };
            };
          }
        ];
    expected = ''
      [foo]
      bar=1
      bar=2
    '';
  };

  iniCoercedListToValue = shouldPass rec {
    format = formats.ini {
      listToValue = lib.concatMapStringsSep ", " (lib.generators.mkValueStringDefault { });
      atomsCoercedToLists = true;
    };
    input =
      format.type.merge
        [ ]
        [
          {
            file = "format-test-inner-iniCoercedListToValue";
            value = {
              foo = {
                bar = 1;
              };
            };
          }
          {
            file = "format-test-inner-iniCoercedListToValue";
            value = {
              foo = {
                bar = 2;
              };
            };
          }
        ];
    expected = ''
      [foo]
      bar=1, 2
    '';
  };

  iniCoercedNoLists = shouldFail {
    format = formats.ini { atomsCoercedToLists = true; };
    input = {
      foo = {
        bar = 1;
      };
    };
  };

  iniNoCoercedNoLists = shouldFail {
    format = formats.ini { atomsCoercedToLists = false; };
    input = {
      foo = {
        bar = 1;
      };
    };
  };

  iniWithGlobalNoSections = shouldPass {
    format = formats.iniWithGlobalSection { };
    input = { };
    expected = "";
  };

  iniWithGlobalOnlySections = shouldPass {
    format = formats.iniWithGlobalSection { };
    input = {
      sections = {
        foo = {
          bar = "baz";
        };
      };
    };
    expected = ''
      [foo]
      bar=baz
    '';
  };

  iniWithGlobalOnlyGlobal = shouldPass {
    format = formats.iniWithGlobalSection { };
    input = {
      globalSection = {
        bar = "baz";
      };
    };
    expected = ''
      bar=baz

    '';
  };

  iniWithGlobalWrongSections = shouldFail {
    format = formats.iniWithGlobalSection { };
    input = {
      foo = { };
    };
  };

  iniWithGlobalEverything = shouldPass {
    format = formats.iniWithGlobalSection { };
    input = {
      globalSection = {
        bar = true;
      };
      sections = {
        foo = {
          bool = true;
          int = 10;
          float = 3.141;
          str = "string";
        };
      };
    };
    expected = ''
      bar=true

      [foo]
      bool=true
      float=3.141000
      int=10
      str=string
    '';
  };

  iniWithGlobalListToValue = shouldPass {
    format = formats.iniWithGlobalSection {
      listToValue = lib.concatMapStringsSep ", " (lib.generators.mkValueStringDefault { });
    };
    input = {
      globalSection = {
        bar = [
          null
          true
          "test"
          1.2
          10
        ];
        baz = false;
        qux = "qux";
      };
      sections = {
        foo = {
          bar = [
            null
            true
            "test"
            1.2
            10
          ];
          baz = false;
          qux = "qux";
        };
      };
    };
    expected = ''
      bar=null, true, test, 1.200000, 10
      baz=false
      qux=qux

      [foo]
      bar=null, true, test, 1.200000, 10
      baz=false
      qux=qux
    '';
  };

  iniWithGlobalCoercedDuplicateKeys = shouldPass rec {
    format = formats.iniWithGlobalSection {
      listsAsDuplicateKeys = true;
      atomsCoercedToLists = true;
    };
    input =
      format.type.merge
        [ ]
        [
          {
            file = "format-test-inner-iniWithGlobalCoercedDuplicateKeys";
            value = {
              globalSection = {
                baz = 4;
              };
              sections = {
                foo = {
                  bar = 1;
                };
              };
            };
          }
          {
            file = "format-test-inner-iniWithGlobalCoercedDuplicateKeys";
            value = {
              globalSection = {
                baz = 3;
              };
              sections = {
                foo = {
                  bar = 2;
                };
              };
            };
          }
        ];
    expected = ''
      baz=3
      baz=4

      [foo]
      bar=2
      bar=1
    '';
  };

  iniWithGlobalCoercedListToValue = shouldPass rec {
    format = formats.iniWithGlobalSection {
      listToValue = lib.concatMapStringsSep ", " (lib.generators.mkValueStringDefault { });
      atomsCoercedToLists = true;
    };
    input =
      format.type.merge
        [ ]
        [
          {
            file = "format-test-inner-iniWithGlobalCoercedListToValue";
            value = {
              globalSection = {
                baz = 4;
              };
              sections = {
                foo = {
                  bar = 1;
                };
              };
            };
          }
          {
            file = "format-test-inner-iniWithGlobalCoercedListToValue";
            value = {
              globalSection = {
                baz = 3;
              };
              sections = {
                foo = {
                  bar = 2;
                };
              };
            };
          }
        ];
    expected = ''
      baz=3, 4

      [foo]
      bar=2, 1
    '';
  };

  iniWithGlobalCoercedNoLists = shouldFail {
    format = formats.iniWithGlobalSection { atomsCoercedToLists = true; };
    input = {
      globalSection = {
        baz = 4;
      };
      foo = {
        bar = 1;
      };
    };
  };

  iniWithGlobalNoCoercedNoLists = shouldFail {
    format = formats.iniWithGlobalSection { atomsCoercedToLists = false; };
    input = {
      globalSection = {
        baz = 4;
      };
      foo = {
        bar = 1;
      };
    };
  };

  keyValueAtoms = shouldPass {
    format = formats.keyValue { };
    input = {
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

  keyValueDuplicateKeys = shouldPass {
    format = formats.keyValue { listsAsDuplicateKeys = true; };
    input = {
      bar = [
        null
        true
        "test"
        1.2
        10
      ];
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

  keyValueListToValue = shouldPass {
    format = formats.keyValue {
      listToValue = lib.concatMapStringsSep ", " (lib.generators.mkValueStringDefault { });
    };
    input = {
      bar = [
        null
        true
        "test"
        1.2
        10
      ];
      baz = false;
      qux = "qux";
    };
    expected = ''
      bar=null, true, test, 1.200000, 10
      baz=false
      qux=qux
    '';
  };

  tomlAtoms = shouldPass {
    format = formats.toml { };
    input = {
      false = false;
      true = true;
      int = 10;
      float = 3.141;
      str = "foo";
      attrs.foo = "foo";
      list = [
        1
        2
      ];
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

  cdnAtoms = shouldPass {
    format = formats.cdn { };
    input = {
      null = null;
      false = false;
      true = true;
      int = 10;
      float = 3.141;
      str = "foo";
      attrs.foo = null;
      list = [
        1
        null
      ];
      path = ./testfile;
    };
    expected = ''
      attrs {
        "foo": null
      }
      "false": false
      "float": 3.141
      "int": 10
      list [
        1,
        null
      ]
      "null": null
      "path": "${./testfile}"
      "str": "foo"
      "true": true
    '';
  };

  # This test is responsible for
  #   1. testing type coercions
  #   2. providing a more readable example test
  # Whereas java-properties/default.nix tests the low level escaping, etc.
  javaProperties = shouldPass {
    format = formats.javaProperties { };
    input = {
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

  luaTable = shouldPass {
    format = formats.lua { };
    input = {
      null = null;
      false = false;
      true = true;
      int = 10;
      float = 3.141;
      str = "foo";
      attrs.foo = null;
      list = [
        null
        null
      ];
      path = ./testfile;
      inline = lib.mkLuaInline "hello('world')";
    };
    expected = ''
      return {
        ["attrs"] = {
          ["foo"] = nil,
        },
        ["false"] = false,
        ["float"] = 3.141,
        ["inline"] = (hello("world")),
        ["int"] = 10,
        ["list"] = {
          nil,
          nil,
        },
        ["null"] = nil,
        ["path"] = "${./testfile}",
        ["str"] = "foo",
        ["true"] = true,
      }
    '';
  };

  luaBindings = shouldPass {
    format = formats.lua {
      asBindings = true;
    };
    input = {
      null = null;
      _false = false;
      _true = true;
      int = 10;
      float = 3.141;
      str = "foo";
      attrs.foo = null;
      list = [
        null
        null
      ];
      path = ./testfile;
      inline = lib.mkLuaInline "hello('world')";
    };
    expected = ''
      _false = false
      _true = true
      attrs = {
        ["foo"] = nil,
      }
      float = 3.141
      inline = (hello("world"))
      int = 10
      list = {
        nil,
        nil,
      }
      null = nil
      path = "${./testfile}"
      str = "foo"
    '';
  };

  nixConfAtoms = shouldPass {
    format = formats.nixConf {
      package = pkgs.nix;
      version = pkgs.nix.version;
      extraOptions = ''ignore-try = false'';
    };
    input = {
      auto-optimise-store = true;
      cores = 0;
      store = "auto";
    };
    # note that null type is hard to test here,
    # as it involves a trailing space our formatter will remove here
    expected = ''
      # WARNING: this file is generated from the nix.* options in
      # your NixOS configuration, typically
      # /etc/nixos/configuration.nix.  Do not edit it!
      auto-optimise-store = true
      cores = 0
      store = auto

      ignore-try = false
    '';
  };

  phpAtoms = shouldPass rec {
    format = formats.php { finalVariable = "config"; };
    input = {
      null = null;
      false = false;
      true = true;
      int = 10;
      float = 3.141;
      str = "foo";
      str_special = "foo\ntesthello'''";
      attrs.foo = null;
      list = [
        null
        null
      ];
      mixed = format.lib.mkMixedArray [ 10 3.141 ] {
        str = "foo";
        attrs.foo = null;
      };
      raw = format.lib.mkRaw "random_function()";
    };
    expected = ''
      <?php
      declare(strict_types=1);
      $config = ['attrs' => ['foo' => null], 'false' => false, 'float' => 3.141000, 'int' => 10, 'list' => [null, null], 'mixed' => [10, 3.141000, 'attrs' => ['foo' => null], 'str' => 'foo'], 'null' => null, 'raw' => random_function(), 'str' => 'foo', 'str_special' => 'foo
      testhello\'\'\'${"'"}, 'true' => true];
    '';
  };

  pythonVars = shouldPass (
    let
      format = formats.pythonVars { };
    in
    {
      inherit format;
      input = {
        _imports = [
          "re"
          "a.b.c"
        ];

        int = 10;
        float = 3.141;
        bool = true;
        str = "foo";
        str_special = "foo\ntesthello'''";
        null = null;
        list = [
          null
          1
          "str"
          true
          (format.lib.mkRaw "1 if True else 2")
        ];
        attrs = {
          foo = null;
          conditional = format.lib.mkRaw "1 if True else 2";
        };
        func = format.lib.mkRaw "re.findall(r'\\bf[a-z]*', 'which foot or hand fell fastest')";
      };
      expected = ''
        import re
        import a.b.c

        attrs = {
            "conditional": 1 if True else 2,
            "foo": None,
        }
        bool = True
        float = 3.141
        func = re.findall(r"\bf[a-z]*", "which foot or hand fell fastest")
        int = 10
        list = [
            None,
            1,
            "str",
            True,
            1 if True else 2,
        ]
        null = None
        str = "foo"
        str_special = "foo\ntesthello''''"
      '';
    }
  );

  phpReturn = shouldPass {
    format = formats.php { };
    input = {
      int = 10;
      float = 3.141;
      str = "foo";
      str_special = "foo\ntesthello'''";
      attrs.foo = null;
    };
    expected = ''
      <?php
      declare(strict_types=1);
      return ['attrs' => ['foo' => null], 'float' => 3.141000, 'int' => 10, 'str' => 'foo', 'str_special' => 'foo
      testhello\'\'\'${"'"}];
    '';
  };

  badgerfishToXmlGenerate = shouldPass {
    format = formats.xml { };
    input = {
      root = {
        "@id" = "123";
        "@class" = "example";
        child1 = {
          "@name" = "child1Name";
          "#text" = "text node";
        };
        child2 = {
          grandchild = "This is a grandchild text node.";
        };
        nulltest = null;
      };
    };
    expected = ''
      <?xml version="1.0" encoding="utf-8"?>
      <root class="example" id="123">
        <child1 name="child1Name">text node</child1>
        <child2>
          <grandchild>This is a grandchild text node.</grandchild>
        </child2>
        <nulltest></nulltest>
      </root>
    '';
  };
}
