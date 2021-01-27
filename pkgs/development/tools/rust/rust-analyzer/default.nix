{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2021-01-25";
    version = "unstable-${rev}";
    sha256 = "1r42cnx5kplql810zc5bcpl0zzm9l8gls64h32nvd7fgad4ixapz";
    cargoSha256 = "0ns26lddiaa1lanamcf8zawh287k4qg8n4brjpqi9s1bxbmd1kc2";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
