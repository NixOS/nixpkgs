{
  replaceVars,
  replaceVarsWith,
  emptyDirectory,
  emptyFile,
  lib,
  runCommand,
  testers,
}:
let
  inherit (testers) testEqualContents testBuildFailure;

  mkTests =
    callReplaceVars: mkExpectation:
    lib.recurseIntoAttrs {
      succeeds = testEqualContents {
        assertion = "replaceVars-succeeds";
        actual = callReplaceVars ./source.txt {
          free = "free";
          "equal in" = "are the same in";
          brotherhood = "shared humanity";
        };

        expected = mkExpectation (
          builtins.toFile "source.txt" ''
            All human beings are born free and are the same in dignity and rights.
            They are endowed with reason and conscience and should act towards
            one another in a spirit of shared humanity.

              -- eroosevelt@humanrights.un.org
          ''
        );
      };

      # There might eventually be a usecase for this, but it's not supported at the moment.
      fails-on-directory =
        runCommand "replaceVars-fails" { failed = testBuildFailure (callReplaceVars emptyDirectory { }); }
          ''
            grep -e "ERROR: file.*empty-directory.*does not exist" $failed/testBuildFailure.log
            touch $out
          '';

      fails-in-build-phase =
        runCommand "replaceVars-fails"
          { failed = testBuildFailure (callReplaceVars emptyFile { not-found = "boo~"; }); }
          ''
            grep -e "ERROR: pattern @not-found@ doesn't match anything in file.*empty-file" $failed/testBuildFailure.log
            touch $out
          '';

      fails-in-check-phase =
        runCommand "replaceVars-fails"
          {
            failed =
              let
                src = builtins.toFile "source.txt" ''
                  Header.
                  before @whatIsThis@ middle @It'sOdd2Me@ after.
                  @cannot detect due to space@
                  Trailer.
                '';
              in
              testBuildFailure (callReplaceVars src { });
          }
          ''
            grep -e "unsubstituted Nix identifiers.*source.txt" $failed/testBuildFailure.log
            grep -F "@whatIsThis@" $failed/testBuildFailure.log
            grep -F "@It'sOdd2Me@" $failed/testBuildFailure.log
            grep -F 'more precise `substitute` function' $failed/testBuildFailure.log

            # Shouldn't see irrelevant details.
            ! grep -q -E -e "Header|before|middle|after|Trailer" $failed/testBuildFailure.log

            # Shouldn't see the "cannot detect" version.
            ! grep -q -F "cannot detect due to space" $failed/testBuildFailure.log

            touch $out
          '';

      succeeds-with-exemption = testEqualContents {
        assertion = "replaceVars-succeeds";
        actual = callReplaceVars ./source.txt {
          free = "free";
          "equal in" = "are the same in";
          brotherhood = null;
        };

        expected = mkExpectation (
          builtins.toFile "source.txt" ''
            All human beings are born free and are the same in dignity and rights.
            They are endowed with reason and conscience and should act towards
            one another in a spirit of @brotherhood@.

              -- eroosevelt@humanrights.un.org
          ''
        );
      };

      fails-in-check-phase-with-exemption =
        runCommand "replaceVars-fails"
          {
            failed =
              let
                src = builtins.toFile "source.txt" ''
                  @a@
                  @b@
                  @c@
                '';
              in
              testBuildFailure (
                callReplaceVars src {
                  a = "a";
                  b = null;
                }
              );
          }
          ''
            grep -e "unsubstituted Nix identifiers.*source.txt" $failed/testBuildFailure.log
            grep -F "@c@" $failed/testBuildFailure.log
            ! grep -F "@b@" $failed/testBuildFailure.log

            touch $out
          '';

      fails-in-check-phase-with-bad-exemption =
        runCommand "replaceVars-fails"
          {
            failed =
              let
                src = builtins.toFile "source.txt" ''
                  @a@
                  @b@
                '';
              in
              testBuildFailure (
                callReplaceVars src {
                  a = "a";
                  b = null;
                  c = null;
                }
              );
          }
          ''
            grep -e "ERROR: pattern @c@ doesn't match anything in file.*source.txt" $failed/testBuildFailure.log

            touch $out
          '';
    };
in
{
  replaceVars = mkTests replaceVars lib.id;
  replaceVarsWith =
    mkTests
      (
        src: replacements:
        replaceVarsWith {
          inherit src replacements;
          dir = "bin";
          isExecutable = true;
        }
      )
      (
        file:
        runCommand "expected" { inherit file; } ''
          install -Dm755 "$file" "$out/bin/$(stripHash "$file")"
        ''
      );
}
