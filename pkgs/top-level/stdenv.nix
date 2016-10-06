{ system, bootStdenv, noSysDirs, config, crossSystem, platform, lib, allPackages }:

rec {
  allStdenvs = import ../stdenv {
    inherit system allPackages platform config lib;
  };

  defaultStdenv = allStdenvs.stdenv // { inherit platform; };

  stdenv =
    if bootStdenv != null then
      bootStdenv // { inherit platform; }
    else if crossSystem != null then
      (allPackages { bootStdenv = defaultStdenv; }).stdenvCross
    else if (config.replaceStdenv or null) != null then
      config.replaceStdenv {
        pkgs = allPackages {
          config = removeAttrs config [ "replaceStdenv" ];
        };
      }
    else
      defaultStdenv;
}
