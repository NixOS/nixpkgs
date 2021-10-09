{ lib, buildFishPlugin, fetchFromGitHub, fishtape }:

buildFishPlugin rec {
  pname = "replay";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "replay.fish";
    rev = version;
    sha256 = "sha256-Q/9YVdiRSJw1SdcfQv2h7Lj6EyFustRk+kmh1eRRQ6k=";
  };

  checkPlugins = [ fishtape ];
  checkFunctionDirs = [ "functions" ];
  checkPhase = "fishtape tests/*.fish";

  meta = with lib; {
    description = "Run Bash commands replaying changes in Fish";
    homepage = "https://github.com/jorgebucaran/replay.fish";
    license = licenses.mit;
    maintainers = with maintainers; [ vanilla ];
  };
}
