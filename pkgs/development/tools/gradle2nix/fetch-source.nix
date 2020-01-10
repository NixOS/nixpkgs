{ pkgs ? (import ../../../../. {})
, fetchFromGitHub ? pkgs.fetchFromGitHub
}:

fetchFromGitHub {
  owner  = "tadfisher";
  repo   = "gradle2nix";
  rev    = "3afaaa373ae029aab8090d777013fcf5012bae59";
  sha256 = "0qmfmpbpmqsvhy7wfj19v8ih0qagraw4x6n43l4gibimmsw5l7bf";
}
