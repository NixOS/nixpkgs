let lists = import ./lists.nix; in

rec {
  gnu = linux; /* ++ hurd ++ kfreebsd ++ ... */
  linux = ["i686-linux" "x86_64-linux" "powerpc-linux" "armv5tel-linux"
    "mips64-linux"];
  darwin = ["i686-darwin" "powerpc-darwin" "x86_64-darwin"];
  freebsd = ["i686-freebsd" "x86_64-freebsd" "powerpc-freebsd"];
  openbsd = ["i686-openbsd" "x86_64-openbsd"];
  netbsd = ["i686-netbsd" "x86_64-netbsd"];
  cygwin = ["i686-cygwin"];
  unix = linux ++ darwin ++ freebsd ++ openbsd;
  all = linux ++ darwin ++ cygwin ++ freebsd ++ openbsd;
  allBut = platform: lists.filter (x: platform != x) all;
  mesaPlatforms = linux ++ darwin ++ freebsd;
}
