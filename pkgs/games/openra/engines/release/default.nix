{ fetchFromGitHub }:

rec {
  name = "release";
  version = "20230225";
  src = fetchFromGitHub {
    owner = "OpenRA";
    repo = "OpenRA";
    rev = "${name}-${version}";
    sha256 = "sha256-f1OwyxNNn1Wh5sfz4s81bbHDY6ot2tvjMD8EK87Hc7k=";
  };

  deps = ./deps.nix;
}
