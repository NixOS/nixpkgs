{ checkAllExecutables, coreutils }:
{
  versions = checkAllExecutables coreutils {
    skipRegexp = "(false|test)";
    outputRegexp = "(GNU coreutils|Free Software Foundation)";
  };
  exit-codes = checkAllExecutables coreutils {
    outputRegexp = null;
  };
}
