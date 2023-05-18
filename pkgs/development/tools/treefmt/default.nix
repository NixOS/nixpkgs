{ lib, rustPlatform, fetchFromGitHub }:
rustPlatform.buildRustPackage rec {
  pname = "treefmt";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "numtide";
    repo = "treefmt";
    rev = "v${version}";
    hash = "sha256-v+hXWyrY0GfSgXeqgYLgoOmeiHsZyhRO9Fmj5rPiNJ8=";
  };

  cargoSha256 = "sha256-/WyaZxRFYJmz/qRp2s2v8swdwAtuNR7KXND20IzQoy8=";

  meta = {
    description = "one CLI to format the code tree";
    homepage = "https://github.com/numtide/treefmt";
    license = lib.licenses.mit;
    maintainers = lib.teams.numtide.members;
  };
}
