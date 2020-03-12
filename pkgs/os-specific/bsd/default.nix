{ callPackages, recurseIntoAttrs }:

{
  netbsd = recurseIntoAttrs (callPackages ./netbsd {});
}
