# To run these tests:
# $ nix build --file . tests.stdenv-functions
# or
# $ nix-build -A tests.stdenv-functions

{
  lib,
  testers,
  runCommand,
  emptyFile,
}:
{
  isExecutable = lib.recurseIntoAttrs {
    happy = runCommand "isExecutable-happy" { } ''
      touch f
      chmod a+x f
      isExecutable f
      touch -- "$out"
    '';
    emptyFile = runCommand "isExecutable-emptyFile" { } ''
      touch emptyFile
      isExecutable emptyFile && {
        echo 'isExecutable must fail for non-executable files'
        false
      }
      touch -- "$out"
    '';
    emptyDirectory = runCommand "isExecutable-emptyDirectory" { } ''
      mkdir emptyDirectory
      isExecutable emptyDirectory && {
        echo 'isExecutable must fail for directories'
        false
      }
      touch -- "$out"
    '';
  };

  checkDuplicateProgramsInUnixPATH = lib.recurseIntoAttrs {
    happy = testers.testEqualContents {
      assertion = "PATH does not have duplicate programs";
      expected = emptyFile;
      actual = runCommand "checkDuplicateProgramsInUnixPATH-happy" { } ''
        mkdir foo bar
        touch foo/foo bar/bar
        chmod a+x foo/foo bar/bar
        PATH=$PWD/foo:$PWD/bar _checkDuplicateProgramsInUnixPATH >"$out"
      '';
    };

    emptyPath = testers.testEqualContents {
      assertion = "Empty PATH does not have duplicate programs";
      expected = emptyFile;
      actual = runCommand "checkDuplicateProgramsInUnixPATH-emptyPath" { } ''
        PATH= _checkDuplicateProgramsInUnixPATH >"$out"
      '';
    };

    emptyPathElement = testers.testEqualContents {
      assertion = "Empty path element is current working directory";
      expected = builtins.toFile "checkDuplicateProgramsInUnixPATH-emptyPathElement-golden" ''
        WARNING: final PATH contains 2 instances of foo executable (the first is ./foo)
      '';
      actual = runCommand "checkDuplicateProgramsInUnixPATH-emptyPathElement" { } ''
        touch foo
        chmod a+x foo
        mkdir bar
        touch bar/foo
        chmod a+x bar/foo
        PATH=:$PWD/bar _checkDuplicateProgramsInUnixPATH >"$out"
      '';
    };

    nonConsecutiveRepetitionInPathElements = testers.testEqualContents {
      assertion = "Handles non-consecutive repetition in PATH elements";
      expected = builtins.toFile "checkDuplicateProgramsInUnixPATH-nonConsecutiveRepetitionInPathElements-golden" ''
        WARNING: final PATH contains 2 instances of a executable (the first is a1/a)
      '';
      actual = runCommand "checkDuplicateProgramsInUnixPATH-nonConsecutiveRepetitionInPathElements" { } ''
        mkdir a1 && touch a1/a && chmod +x a1/a
        mkdir a2 && touch a2/a && chmod +x a2/a
        PATH=a1:a2:a1:a2:a1 _checkDuplicateProgramsInUnixPATH >"$out"
      '';
    };

    nonExecutable = testers.testEqualContents {
      assertion = "Ignores files without executable file mode bit set";
      expected = emptyFile;
      actual = runCommand "checkDuplicateProgramsInUnixPATH-nonExecutable" { } ''
        mkdir upper lower
        touch {upper,lower}/{foo,bar}
        chmod a+x upper/foo lower/bar
        PATH=upper:lower _checkDuplicateProgramsInUnixPATH >"$out"
      '';
    };

    pathWithSpaces = testers.testEqualContents {
      assertion = "Handles PATH and executables with spaces";
      expected = builtins.toFile "checkDuplicateProgramsInUnixPATH-pathWithSpaces-golden" ''
        WARNING: final PATH contains 3 instances of c executable (the first is a\ b/c)
      '';
      actual = runCommand "checkDuplicateProgramsInUnixPATH-pathWithSpaces" { } ''
        mkdir 'a b' a b
        touch 'a b/a b' 'a b/c' a/a a/c b/b b/c
        chmod a+x 'a b/a b' 'a b/c' a/a a/c b/b b/c
        PATH='a b':a:b _checkDuplicateProgramsInUnixPATH >"$out"
      '';
    };

    debugOutput =
      let
        foo = runCommand "foo" { } ''
          mkdir -p -- "$out/bin"
          touch -- "$out/bin/foo"
          chmod a+x -- "$out/bin/foo"
        '';
        bar = runCommand "bar" { } ''
          mkdir -p -- "$out/bin"
          touch -- "$out/bin/bar"
          chmod a+x -- "$out/bin/bar"
        '';
        foobar = runCommand "foobar" { } ''
          mkdir -p -- "$out"/bin
          touch -- "$out"/bin/{foo,bar}
          chmod a+x -- "$out"/bin/{foo,bar}
        '';
      in
      testers.testEqualContents {
        assertion = "Empty path element is current working directory";
        expected =
          runCommand "checkDuplicateProgramsInUnixPATH-debugOutput-golden" { inherit foobar foo bar; }
            ''
              for f in foo bar; do
                printf "WARNING: final PATH contains 2 instances of $f executable\n"
                printf "  $f ⇒\n"
                printf "    %q/bin/$f\n" "$foobar"
                printf "    %q/bin/$f\n" "''${!f}"
              done >"$out"
            '';
        actual =
          runCommand "checkDuplicateProgramsInUnixPATH-debugOutput"
            {
              testPath = lib.makeBinPath [
                foobar
                foo
                bar
              ];
            }
            ''
              PATH=$testPath NIX_DEBUG=1 _checkDuplicateProgramsInUnixPATH >"$out"
            '';
      };
  };
}
