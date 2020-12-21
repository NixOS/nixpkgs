{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-12-21";
    version = "unstable-${rev}";
    sha256 = "sha256:0yz4mc6vbqrgnziscziy2z0241zmx5kzsiy4hhw5p70hvmb5nm9h";
    cargoSha256 = "sha256:1mqd0i397nwcdhm21rv4w38n3mqrz0cvwk89vmhi8mwv37pqsnxx";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
