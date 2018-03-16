{ coreutils }:
{
  versions = import ./temporary-helpers/check-executables.nix rec {
    package = coreutils;
    skipRegexp = "(false|test)";
    outputRegexp = "(GNU coreutils|Free Software Foundation)";
    meta.description = "Check that most of the executables in the ${package.name} react reasonably to --version";
  };
  exit-codes = import ./temporary-helpers/check-executables.nix rec {
    package = coreutils;
    outputRegexp = null;
    meta.description = "Check that the executables in the ${package.name} do not fail with special return codes";
  };
}
