{ callPackage, ... }@args:

callPackage ./generic.nix (args // {
  version = "1.11.6";
  sha256 = "1xmn5m2wjx1n11lwwlcg71836acb43gwq9ngk088jpx78liqlgr2";
})
