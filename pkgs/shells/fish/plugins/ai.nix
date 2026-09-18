{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "ai";
  version = "0-unstable-2025-02-14";

  src = fetchFromGitHub {
    owner = "derekstavis";
    repo = "fish-ai";
    rev = "b22952232fbf71287c56c8a09c8be2f938d33b51";
    sha256 = "sha256-ogkbNX+e5qaEbW+iO3na8JC2Xfk/9BndXRm2AcHyOmc=";
  };

  meta = {
    description = "Don't remember the command, use AI to figure out";
    homepage = "https://github.com/derekstavis/fish-ai";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
  };
}
