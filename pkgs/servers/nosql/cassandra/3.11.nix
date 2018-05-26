{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "3.11.2";
  sha256 = "0867i3irsji3qkjpp2s171xmjf2r8yhwzhs24ka8hljxv457f8p9";
})
