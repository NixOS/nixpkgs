{
  substitute,
  testers,
  runCommand,
}:
{

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

  singleReplace = testers.testEqualContents {
    assertion = "substitute-single-replace";
    actual = substitute {
      src = builtins.toFile "source" ''
        Hello world!
      '';
      substitutions = [
        "--replace-fail"
        "world"
        "paul"
      ];
    };
    expected = builtins.toFile "expected" ''
      Hello paul!
    '';
  };

  multipleReplace = testers.testEqualContents {
    assertion = "substitute-multiple-replace";
    actual = substitute {
      src = builtins.toFile "source" ''
        Hello world!
      '';
      substitutions = [
        "--replace-fail"
        "Hello"
        "Bye"
        "--replace-fail"
        "world"
        "Peter"

      ];
    };
    expected = builtins.toFile "expected" ''
      Bye Peter!
    '';
  };

}
