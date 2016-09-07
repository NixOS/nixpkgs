# This file helps us test some assertions about the treatment of the
# crossSystem top-level argument.
#
# Ideally, the presence of a crossSystem argument should not affect
# *any* native derivations.  For now, we just test a few derivations
# that are likely to have problems.

rec {
  topLevel = import ../pkgs/top-level;

  pkgs = topLevel {
    system = builtins.currentSystem;
    crossSystem = null;
  };

  pkgsWithCross = topLevel {
    system = builtins.currentSystem;
    crossSystem = {
      config = "foosys";
      libc = "foolibc";
    };
  };

  sameLibiconv = pkgs.libiconv == pkgsWithCross.libiconv;
  sameGcc6 = pkgs.gcc6 == pkgsWithCross.gcc6;
  sameGcc5 = pkgs.gcc5 == pkgsWithCross.gcc5;
  sameGcc49 = pkgs.gcc49 == pkgsWithCross.gcc49;
  sameGcc48 = pkgs.gcc48 == pkgsWithCross.gcc48;
  sameGcc45 = pkgs.gcc45 == pkgsWithCross.gcc45;

  # TODO: Test that *all* GCCs are the same:
  # sameGcc = sameGcc6 && sameGcc5 && sameGcc49 && sameGcc48 && sameGcc45;

  testsPass = sameLibiconv && sameGcc5;
}
