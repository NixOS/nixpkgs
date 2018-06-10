{ callPackages, recurseIntoAttrs }:

rec {
  netbsd = recurseIntoAttrs (callPackages ./netbsd {});
}
