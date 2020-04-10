{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-04-06";
    version = "unstable-${rev}";
    sha256 = "0cm12707rq88w9yd4kkh26pnaqfvif6yyshk42pfi9vyv4ljfpcv";
    cargoSha256 = "0q1qwji407pmklwb27z2jwyrvwyn8zkmrwm4nbcgk53ci4p6a17k";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
