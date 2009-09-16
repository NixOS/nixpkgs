let
  lists = import ./lists.nix;
in
rec {
  gnu = linux;  /* ++ hurd ++ kfreebsd ++ ... */
  linux = ["i686-linux" "x86_64-linux" "powerpc-linux"];
  darwin = ["i686-darwin" "powerpc-darwin"];
  freebsd = ["i686-freebsd" "x86_64-freebsd" "powerpc-freebsd"];
  cygwin = ["i686-cygwin"];
  all = linux ++ darwin ++ cygwin ++ freebsd;
  allBut = platform: lists.filter (x: platform != x) all;
  mesaPlatforms = linux ++ darwin ++ freebsd;
}
