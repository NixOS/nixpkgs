{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-03-16";
    version = "unstable-${rev}";
    sha256 = "0h1dpf9jcdf15qvqmq10giiqmcwdnhw3r8jr26jyh8sk0331i3am";
    cargoSha256 = "1a6gyankb6jxrz8k8cwpdiaq9m5m4ca7rfcpdm0a2qz7z9nm7k34";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
