{ pkgs, callPackage }:

{
  rust-analyzer-unwrapped = callPackage ./generic.nix rec {
    rev = "2020-10-19";
    version = "unstable-${rev}";
    sha256 = "1xvyk1d26zn1d9i42h78qsm6bg57nhn1rgr46jwa46gsb31nabjh";
    cargoSha256 = "18s5yrc9fdj2ndylwyf07l0kmwxka7mnbj254xmq3g7ragw71xjw";
  };

  rust-analyzer = callPackage ./wrapper.nix {} {
    unwrapped = pkgs.rust-analyzer-unwrapped;
  };
}
