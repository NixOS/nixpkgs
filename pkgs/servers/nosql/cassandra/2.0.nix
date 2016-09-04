{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.0.16";
  sha256 = "1fpvgmakmxy1lnygccpc32q53pa36bwy0lqdvb6hsifkxymdw8y5";
})
