{
  buildFishPlugin,
  lib,
  fetchFromGitHub,
}:
buildFishPlugin {
  pname = "getopts";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "jorgebucaran";
    repo = "getopts.fish";
    rev = "4b74206725c3e11d739675dc2bb84c77d893e901";
    sha256 = "sha256-9hRFBmjrCgIUNHuOJZvOufyLsfreJfkeS6XDcCPesvw=";
  };

  meta = {
    description = "Parse CLI options in fish";
    homepage = "https://github.com/jorgebucaran/getopts.fish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ llakala ];
    platforms = lib.platforms.all;
  };
}
