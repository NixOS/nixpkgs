{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-03-09";
    version = "unstable-${rev}";
    sha256 = "1m97sinfyg43p3crhbjrsgf64bn5pyj7m96ikvznps80w8dnsv5n";
    cargoSha256 = "0rxmyv8va4za0aghwk9765qn4xwd03nnry83mrkjidw0ripka5sf";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
