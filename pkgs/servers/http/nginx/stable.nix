{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.14.2";
  sha256 = "15wppq12qmq8acjs35xfj61czhf9cdc0drnl5mm8hcg3aihryb80";
})
