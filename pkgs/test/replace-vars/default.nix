{
  replaceVars,
  emptyDirectory,
  emptyFile,
  runCommand,
  testers,
}:
let
  inherit (testers) testEqualContents testBuildFailure;
in
{
  # Success case for `replaceVars`.
  replaceVars = testEqualContents {
    assertion = "replaceVars";
    actual = replaceVars ./source.txt {
      free = "free";
      "equal in" = "are the same in";
      brotherhood = "shared humanity";
    };

    expected = builtins.toFile "expected" ''
      All human beings are born free and are the same in dignity and rights.
      They are endowed with reason and conscience and should act towards
      one another in a spirit of shared humanity.

        -- eroosevelt@humanrights.un.org
    '';
  };

  # There might eventually be a usecase for this, but it's not supported at the moment.
  replaceVars-fails-on-directory =
    runCommand "replaceVars-fails" { failed = testBuildFailure (replaceVars emptyDirectory { }); }
      ''
        grep -e "ERROR: file.*empty-directory.*does not exist" $failed/testBuildFailure.log
        touch $out
      '';

  replaceVars-fails-in-build-phase =
    runCommand "replaceVars-fails"
      { failed = testBuildFailure (replaceVars emptyFile { not-found = "boo~"; }); }
      ''
        grep -e "ERROR: pattern @not-found@ doesn't match anything in file.*empty-file" $failed/testBuildFailure.log
        touch $out
      '';

  replaceVars-fails-in-check-phase =
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
          testBuildFailure (replaceVars src { });
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
}
