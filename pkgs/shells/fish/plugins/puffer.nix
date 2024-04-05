{
  lib,
  buildFishPlugin,
  fetchFromGitHub,
}:

buildFishPlugin rec {
  pname = "puffer";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "nickeb96";
    repo = "puffer-fish";
    rev = "v${version}";
    hash = "sha256-2niYj0NLfmVIQguuGTA7RrPIcorJEPkxhH6Dhcy+6Bk=";
  };

  meta = {
    description = "Text Expansions for Fish";
    homepage = "https://github.com/nickeb96/puffer-fish";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ quantenzitrone ];
  };
}
