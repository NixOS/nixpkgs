{ coreutils }:
{
  versions = import ./temporary-helpers/check-executables.nix {
    package = coreutils;
    skipRegexp = "(false|test)";
    outputRegexp = "(GNU coreutils|Free Software Foundation)";
  };
  exit-codes = import ./temporary-helpers/check-executables.nix {
    package = coreutils;
    outputRegexp = null;
  };
}
