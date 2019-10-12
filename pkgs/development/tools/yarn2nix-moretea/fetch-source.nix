{ pkgs ? (import ../../../../. {})
, fetchFromGitHub ? pkgs.fetchFromGitHub
}:

fetchFromGitHub {
  owner  = "moretea";
  repo   = "yarn2nix";
  rev    = "3f2dbb08724bf8841609f932bfe1d61a78277232";
  sha256 = "142av7dwviapsnahgj8r6779gs2zr17achzhr8b97s0hsl08dcl2";
}
