{ callPackages, lib }:

rec {
  netbsd = lib.recurseIntoAttrs (callPackages ./netbsd {});
}
