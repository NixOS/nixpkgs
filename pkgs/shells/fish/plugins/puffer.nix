{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "puffer";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "nickeb96";
    repo = "puffer-fish";
    rev = "v${version}";
    hash = "sha256-MdeegvBu/AqvaMu0g1UHKBvfb6SHUiTUiA62h87r/Xg=";
  };

  meta = {
    description = "Text Expansions for Fish";
    homepage = "https://github.com/nickeb96/puffer-fish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
}
