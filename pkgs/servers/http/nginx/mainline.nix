{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.5";
  sha256 = "1xmn5m1wjx1n11lwwlcg71836acb43gwq9ngk088jpx78liqlgr2";
})
