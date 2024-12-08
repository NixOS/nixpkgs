{ substitute, testers, runCommand }:
let
  # Ofborg doesn't allow any traces on stderr,
  # so mock `lib` to not trace warnings,
  # because substitute gives a deprecation warning
  substituteSilent = substitute.override (prevArgs: {
    lib = prevArgs.lib.extend (finalLib: prevLib: {
      trivial = prevLib.trivial // {
        warn = msg: value: value;
      };
    });
  });
in {

  substitutions = testers.testEqualContents {
    assertion = "substitutions-spaces";
    actual = substitute {
      src = builtins.toFile "source" ''
        Hello world!
      '';
      substitutions = [
        "--replace-fail"
        "Hello world!"
        "Yo peter!"
      ];
    };
    expected = builtins.toFile "expected" ''
      Yo peter!
    '';
  };

  legacySingleReplace = testers.testEqualContents {
    assertion = "substitute-single-replace";
    actual = substituteSilent {
      src = builtins.toFile "source" ''
        Hello world!
      '';
      replacements = [
        "--replace-fail" "world" "paul"
      ];
    };
    expected = builtins.toFile "expected" ''
      Hello paul!
    '';
  };

  legacyString = testers.testEqualContents {
    assertion = "substitute-string";
    actual = substituteSilent {
      src = builtins.toFile "source" ''
        Hello world!
      '';
      # Not great that this works at all, but is supported
      replacements = "--replace-fail world string";
    };
    expected = builtins.toFile "expected" ''
      Hello string!
    '';
  };

  legacySingleArg = testers.testEqualContents {
    assertion = "substitute-single-arg";
    actual = substituteSilent {
      src = builtins.toFile "source" ''
        Hello world!
      '';
      # Not great that this works at all, but is supported
      replacements = [
        "--replace-fail world list"
      ];
    };
    expected = builtins.toFile "expected" ''
      Hello list!
    '';
  };

  legacyVar = testers.testEqualContents {
    assertion = "substitute-var";
    actual = substituteSilent {
      src = builtins.toFile "source" ''
        @greeting@ @name@!
      '';
      # Not great that this works at all, but is supported
      replacements = [
        "--subst-var name"
        "--subst-var-by greeting Yo"
      ];
      name = "peter";
    };
    expected = builtins.toFile "expected" ''
      Yo peter!
    '';
  };


}
