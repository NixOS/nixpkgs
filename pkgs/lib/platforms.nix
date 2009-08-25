let
  lists = import ./lists.nix;
in
rec {
  linux = ["i686-linux" "x86_64-linux"];
  darwin = ["i686-darwin"];
  cygwin = ["i686-cygwin"];
  all = linux ++ darwin ++ cygwin;
  allBut = platform: lists.filter (x: platform != x) all;
}
