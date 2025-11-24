{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
let
  self = buildFishPlugin {
    pname = "spark";
    version = "1.2.0";

    src = fetchFromGitHub {
      owner = "jorgebucaran";
      repo = "spark.fish";
      rev = "refs/tags/${self.version}";
      hash = "sha256-AIFj7lz+QnqXGMBCfLucVwoBR3dcT0sLNPrQxA5qTuU=";
    };

    meta = {
      description = "Sparklines for Fish";
      homepage = "https://github.com/jorgebucaran/spark.fish";
      license = lib.licenses.mit;
      maintainers = with lib.maintainers; [ theobori ];
    };
  };
in
self
