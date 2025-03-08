import ./generic.nix rec {
  version = "2.5.9";
  hash = "sha256-YyvlMeBux80OpVhsCv+6IVxKXFRsgdr+1siupMR13JM=";
  rev = "R${builtins.replaceStrings [ "." ] [ "_" ] version}";
}
