{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "bang-bang";
  version = "0-unstable-2023-07-23";

  src = fetchFromGitHub {
    owner = "oh-my-fish";
    repo = "plugin-bang-bang";
    rev = "ec991b80ba7d4dda7a962167b036efc5c2d79419";
    hash = "sha256-oPPCtFN2DPuM//c48SXb4TrFRjJtccg0YPXcAo0Lxq0=";
  };

  meta = {
    description = "Bash style history substitution for Oh My Fish";
    homepage = "https://github.com/oh-my-fish/plugin-bang-bang";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ theobori ];
  };
}
